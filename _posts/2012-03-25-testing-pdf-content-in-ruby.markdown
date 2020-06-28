---
layout: post
title: Testing PDF Content in Ruby
---
Earlier this year I decided enough was enough and I was proud to announce
[version 1.0](https://groups.google.com/forum/?fromgroups#!topic/pdf-reader/EUVGMWC0BCA)
of [pdf-reader](http://rubygems.org/gems/pdf-reader), my ruby library for reading PDFs.

The most common reason to read a PDF in ruby seems to be asserting they contain
the correct output in tests, so here's how to go about it with rspec.

First install it.

{% highlight bash %}
    gem install pdf-reader
{% endhighlight %}

Then add it to your Gemfile.

{% highlight ruby %}
    gem 'pdf-reader', require => 'pdf/reader'
{% endhighlight %}

Finally, add some specs.

{% highlight ruby %}
    require 'stringio'

    describe SomeClass do
      subject { SomeClass.new }

      describe "the make_my_pdf method" do
        it "should generate a single page PDF" do
          pdf    = subject.make_my_pdf
          reader = PDF::Reader.new(StringIO.new(pdf))

          reader.pages.size.should == 1
        end

        it "should say 'Hello World' on page 1" do
          pdf    = subject.make_my_pdf
          reader = PDF::Reader.new(StringIO.new(pdf))

          reader.page(1).text.should include("Hello World")
        end
      end
    end
{% endhighlight %}

Running the same assertions with capybara request specs looks very similar.

{% highlight ruby %}
    require 'stringio'

    feature "Downloading a PDF report"

      scenario "that has a single page" do
        visit "/pdf"
        pdf    = page.source
        reader = PDF::Reader.new(StringIO.new(pdf))

        reader.pages.size.should == 1
      end

      scenario "that says 'Hello World' on page 1" do
        visit "/pdf"
        pdf    = page.source
        reader = PDF::Reader.new(StringIO.new(pdf))

        reader.page(1).text.should include("Hello World")
      end
    end
{% endhighlight %}
