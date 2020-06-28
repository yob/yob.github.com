---
layout: post
---
For the vast majority of string attributes on my ActiveRecord models, I want a
blank string submitted by the user to be saved to the database as NULL. I
started writing a small Rails plugin to achieve my goal via a before_validation
callback, but then found an existing plugin,
Ryan McGeary's [StripAttributes](http://github.com/rmm5t/strip_attributes) that
does the job just fine. As an added bonus it removes leading and trailing
whitespace as well.

More recently I was processing a large volume of CSV data and creating new
AR records. It turned out the data had some odd [ASCII control
characters](http://asciitable.com/) in it (like 0x0B - vertical tab) that were
causing grief elsewhere in the app.

In this day and age it's rare to require the use of ASCII control characters,
so I built a new plugin to strip them out before a model is saved. The plugin
is essentially a fork of StripAttributes so I won't claim it's innovative, but
it's useful.

[StripControlChars](http://github.com/yob/strip_control_chars) can be found on
github and installed as a gem.

{% highlight sh %}
    gem install strip_control_chars
{% endhighlight %}

Load the gem from your environment.rb file:

{% highlight ruby %}
    config.gem 'strip_control_chars'
{% endhighlight %}

And add the macro to the models you want to use it with:

{% highlight ruby %}
    class Product < ActiveRecord::Base
      strip_control_chars!
    end

    p = Product.create!(:name => "Some\x0BWidget")
    puts p.name
    => Some Widget
{% endhighlight %}

The following bytes will be replaced with a standard space (0x20): 0x00, 0x01,
0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x0B, 0x0C, 0x0E, 0x0F, 0x10, 0x11,
0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E,
0x1F

Whilst I was making plugins based on StripAttributes, I made another that
replaces various "smart quotes" with their ASCII equivalents. It's somewhat
more controversial than StripControlChars and will probably get me in trouble with
typographers, but them's the breaks. It operates in the same way as
StripControlChars, so doesn't really deserve its own blog post. Check it out on
github: [DumbQuotes](https://github.com/yob/dumb_quotes)
