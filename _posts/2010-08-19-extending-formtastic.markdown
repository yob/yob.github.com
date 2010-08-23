---
layout: default
---
[Formtastic](http://github.com/justinfrench/formtastic) is a great little gem
for cleaning up form code in your Rails view. It provides a neat DSL for
building forms and outputs semantic markup with plenty of hooks for you to
style with.

The project readme has extensive samples, but here's what a simple form might
look like:

{% highlight erb %}
    <% semantic_form_for @meeting do |form| %>
      <% form.inputs do %>
        <%= form.input :title %>
        <%= form.input :week %>
      <% end %>
      <% form.buttons do %>
        <%= form.commit_button %>
      <% end %>
    <% end %>
{% endhighlight %}

Formtastic is smart enough to detect your attribute types and renders an
appropriate form element. If you don't like what it chooses, overriding the
element type is as easy as an extra option to the input method.

One limitation is that it only supports the standard form elements available in
the rails API. What if you want something different - like some fancy image
based thing? or a non-standard date picker? or some new-fandangled HTML5 input
type?

The readme has a tantalising hint on custom inputs, but doesn't go into much
detail

{% highlight text %}
    If you want to add your own input types to encapsulate your own logic or
    interface patterns, you can do so by subclassing SemanticFormBuilder and
    configuring Formtastic to use your custom builder class.
{% endhighlight %}

Imagine your model has a date attribute that always stores a Monday. You want
users to pick a date by selecting from a list of options formatted with
commercial weeks (week 22 2010, week 23 2010, etc).

Start by creating lib/my_custom_builder.rb. Create a class that extends the default
formtastic builder and add your own input type. The default builder has a heap
of helper methods you can use, so have that open at the same time.

{% highlight ruby %}
    class MyCustomBuilder < Formtastic::SemanticFormBuilder
      def commercial_week_input(method, options = {})
        options = set_include_blank(options)
        html_options = options.delete(:input_html) || {}
        input_name = generate_association_input_name(method)
        selected_value = @object.send(input_name)
        selected_value = selected_value.strftime("%Y-%m-%d") if selected_value.respond_to?(:strftime)
        select_options = strip_formtastic_options(options).merge(:selected => selected_value)

        collection = mondays.map { |mon| [mon.strftime("Week %W, %Y"), mon.strftime("%Y-%m-%d")]}

        self.label(method, options_for_label(options)) <<
          self.select(input_name, collection, select_options, html_options)
      end

      private

      # return an array of dates for the next year of mondays
      #
      def mondays
        this_monday = Date.today.beginning_of_week.to_date
        (0..51).map { |i| this_monday + (i*7) }
      end
    end
{% endhighlight %}

Then edit your formtastic settings in config/initializers/formtastic.rb and tell it
to use your new builder instead of the default

{% highlight ruby %}
    Formtastic::SemanticFormHelper.builder = MyCustomBuilder
{% endhighlight %}

Restart your app, and then use the new input type in a form

{% highlight erb %}
    <% semantic_form_for @meeting do |form| %>
      <% form.inputs do %>
        <%= form.input :title %>
        <%= form.input :week, :as => :commercial_week %>
      <% end %>
      <% form.buttons do %>
        <%= form.commit_button %>
      <% end %>
    <% end %>
{% endhighlight %}
