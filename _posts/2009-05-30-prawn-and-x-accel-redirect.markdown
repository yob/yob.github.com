---
layout: post
---
[Prawn](http://prawn.majesticseacreature.com/) is a pure Ruby PDF generation
library. [PrawnTo](http://www.cracklabs.com/prawnto) is a rails plugin that
makes it dead easy to add PDF views to standard rails actions.

I needed to generate a significant number of PDF reports in an app I support
and although Prawnto makes things simple I had a few requirements that meant it
wasn't a good fit:

* I wanted to share my reports across several projects
* I wanted to be able to generate PDFs in situations that weren't responses to
  a HTTP request. For example, for attaching to an email or as part of a
  background job
* I didn't want downloads of large PDFs to tie up one of my rails processes

With these in mind I came up with an alternative (and slightly more complex)
technique for using Prawn in my app. The key features are storing the report
definitions in their own directory (to allow sharing between projects using git
sub modules) and using nginx's X-Accel-Redirect feature to let nginx handle
streaming the generated file to the client. You can read a little about this
feature in the [nginx wiki](http://wiki.nginx.org//NginxXSendfile). Apache has
a similar feature called X-Sendfile that is roughly comparable.

There are a number of steps involved in getting this technique running, so I
will assume you are familiar with both Prawn, nginx and Rails. I have code
snippets inline, or you can view a full sample application at
[github](https://github.com/yob/prawn-rails-xaccelredirect/tree).

Start by editing your config/enviroment.rb file to add the following three
lines. The first tells Rails about the new directory we'll use to store our
reports and the next 2 load prawn.

{% highlight ruby %}
    config.load_paths += %W( #{RAILS_ROOT}/app/reports )
    config.gem "prawn", :version => "0.4.1", :lib => "prawn"
    config.gem "prawn-format", :version => "0.1.1", :lib => "prawn/format"
{% endhighlight %}

Next, edit or create config/initializers/mime_types.rb and add a line to register
the PDF mime type:

{% highlight ruby %}
    Mime::Type.register "application/pdf", :pdf
{% endhighlight %}

Now, create a new class in app/reports/application_report.rb. This class will be
a superclass for all the reports you will be generating.

{% highlight ruby %}
    require 'pathname'

    class ApplicationReport

      attr_reader :path

      def render
        self.__send__(:render_header) if self.respond_to?(:render_header)
        self.__send__(:render_body)   if self.respond_to?(:render_body)
        self.__send__(:render_footer) if self.respond_to?(:render_footer)
        File.open(tmp_file, "w") { |f| f.write pdf.render }
        self
      end

      private

      def pdf(opts = {})
        @path ||= tmp_file
        @pdf ||= ::Prawn::Document.new(opts)
      end

      # choose a file to render our PDF to before sending it to the user
      def tmp_file
        counter = 1
        path = nil
        dir = RAILS_ROOT + "/tmp/pdfs"
        FileUtils.mkdir_p(dir)
        dir = Pathname.new(dir).realpath
        while path.nil? || File.file?(path)
          path = "#{dir}/pdf-#{counter}"
          counter += 1
        end
        path
      end
    end
{% endhighlight %}

Now, create a subclass of ApplicationReport in app/reports/product_report.rb.
This will be your first real report. I've created a sample one here called
ProductReport to display the basic information from my Product model. You will
need to modify it to suit your application.

{% highlight ruby %}
    class ProductReport < ApplicationReport
      def initialize(product)
        @product = product
      end

      def render_header
        pdf.font_size(16) do
          pdf.text "<b>#{@product.description}</b>"
        end
      end

      def render_body
        pdf.font_size(12) do
          pdf.text "<b>Code: </b>#{@product.code}"
          pdf.text "<b>RRP: </b>#{@product.rrp}"
        end
      end
    end
{% endhighlight %}

Next, we need to setup nginx to use the X-Accel-Redirect feature. Add the
following four lines to your nginx config file, changing the path to point to
your own rails app directory. For more information on this step, consult
google. There's plenty of relevant information around.

    location /srv/rails/mypp/tmp/pdfs {
      internal;
      root /;
    }

To simplify using X-Accel-Redirect, add two helper methods to your
ApplicationController:

{% highlight ruby %}
    def x_accel_pdf(path, filename)
      x_accel_redirect(path, :type => "application/pdf", :filename => filename)
    end

    def x_accel_redirect(path, opts ={})
      if opts[:type]
        response.headers['Content-Type'] = opts[:type]
      else
        response.headers['Content-Type'] = "application/octet-stream"
      end
      response.headers['Content-Disposition'] = "attachment;"
      if opts[:filename]
        response.headers['Content-Disposition'] << " filename= \"#{opts[:filename]}\""
      end
      response.headers["X-Accel-Redirect"] = path

      Rails.logger.info "#{path} sent to client using X-Accel-Redirect"

      render :nothing => true
    end
{% endhighlight %}

Finally, add the rendering and X-Accel-Redirect instructions to the relevant
controller action. Since my sample report earlier was to display a single
product, I've added it to the show action on my ProductsController.

{% highlight ruby %}
    class ProductsController < ApplicationController

      ...

      def show
        @product = Product.find(params[:id])

        respond_to do |format|
          format.html
          format.pdf do
            report = ProductReport.new(@product)
            report.render
            x_accel_pdf(report.path, "product-#{@product.id}.pdf")
          end
        end
      end

      ...

    end
{% endhighlight %}

The key lines for generating a report are:

{% highlight ruby %}
    report = ProductReport.new(@product)
    report.render
{% endhighlight %}

I can call these lines any time I need to generate my ProductReport, whether it
be in a controller action like here, a ActionMailer email, or a rake task. The
output will be rendered to disk and I can retrieve the path by calling
report.path.

The key line for using X-Accel-Redirect is:

{% highlight ruby %}
    x_accel_pdf(report.path, "product-#{@product.id}.pdf")
{% endhighlight %}

I can call x\_accel\_pdf() in any controller action and the filename I give it will
be streamed to the client by nginx instead of my rails app.

The setup to all this is a little involved, but once it's in your app adding
new reports is dead simple. A worthwhile tradeoff in my opinion.

The most likely problem you're likely to run into is misconfiguring nginx. For hints
on what might be wrong, make sure you check out the nginx error log.
