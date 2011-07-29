---
layout: default
---
The [PDF spec](http://www.adobe.com/devnet/pdf/pdf_reference.html) is a beast.
Amongst a long list of features it allows transparencies, embedding of flash,
video and javascript, content encryption and multiple colour spaces.

Such features have their place, but sometimes you just need to say no.
Standards like [PDF/A](http://en.wikipedia.org/wiki/PDF/A) and
[PDF/X](http://en.wikipedia.org/wiki/PDF/X) are subsets of the full PDF spec
that target particular use cases like archiving or printing.

To check a given PDF conforms to a required standard you run a preflight check.
There are expensive programs that can preflight, but they're ..... expensive,
and generally hard to script.

I recently released the [preflight](http://rubygems.org/gems/preflight) rubygem
for performing preflight checks from ruby. It's not as full featured as the
commercial options, but it's free and may solve 80% of your problem.

Start by installing the gem

{% highlight bash%}
    gem install preflight
{% endhighlight %}

To check a file passes a PDF/X-1a preflight it's just three lines.

{% highlight ruby %}
    require 'preflight'

    preflight = Preflight::Profiles::PDFX1A.new

    puts preflight.check("somefile.pdf").inspect
{% endhighlight %}

If you need more control over the profile, you can build your own profile.

{% highlight ruby %}
    require "preflight"

    class MyPreflight
      include Preflight::Profile

      rule Preflight::Rules::MaxVersion, 1.4
      rule Preflight::Rules::DocumentId
      rule Preflight::Rules::OnlyEmbeddedFonts
      rule Preflight::Rules::MinPpi, 300
    end

    preflight = MyPreflight.new

    puts preflight.check("somefile.pdf").inspect
{% endhighlight %}

For a list of available rules, check out the classes in the Preflight::Rules
namespace - each class has documentation describing how to use it in a profile.

If the provided rules don't cover everything you need, you can also write your
own.

For more details and examples, check out project on
[github](https://github.com/yob/pdf-preflight).
