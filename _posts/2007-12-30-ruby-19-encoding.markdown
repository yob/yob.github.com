---
layout: post
---
[Ruby 1.9](http://www.ruby-lang.org/en/news/2007/12/25/ruby-1-9-0-released/)
was released last week, and I've been poking around with the changes to the
String class to see what's possible. 1.9 is a development release, so I'm not
planning to start using it in production anytime soon, but it's nice to be able
to test my apps for compatibility with the planned 2.0 release.

In ruby <= 1.8, strings were effectively just byte streams. Those bytes would
often contain text in one encoding or another, but there was no formal way to
record exactly which one (if any; binary data has none). All the default
methods assumed single byte encoding (such as US-ASCII), so behaviour was odd
when the encoding was multibyte (such as UTF8).

1.9 now records the encoding of a string, which allows many of the methods to
be improved to recognise multi-byte strings. For further background on
encodings, read Joel Spolsky's
[article](http://www.joelonsoftware.com/articles/Unicode.html).

Consider the following UTF-8 string:

{% highlight ruby %}
    str = "メインページ"

    str.encoding
    => #<Encoding:UTF-8>
{% endhighlight %}

The size method now returns the size of the string in characters, not bytes. To
get the size in bytes, use the bytesize method.

{% highlight ruby %}
    str.bytesize
    => 18

    str.size
    => 6
{% endhighlight %}

To check if the string contains only ASCII compatible characters, regardless of
the encoding:

{% highlight ruby %}
    str.ascii_only?
    => false
{% endhighlight %}

If Ruby has confused itself and has the wrong encoding recorded, you can
forcibly fix it. The bytestream will not be modified, just ruby's understanding
of what the stream represents.

{% highlight ruby %}
    str.force_encoding("ASCII")
    => "\xE3\x83\xA1\xE3\x82\xA4\xE3\x83\xB3\xE3\x83\x9A\xE3\x83\xBC\xE3\x82\xB8" 

    str.size
    => 18

    str.bytesize
    => 18

    str.force_encoding("UTF-8")
    => "メインページ" 
{% endhighlight %}

Some encodings can be translated to others: the underlying bytestream will be
changed to represent the same characters in the new encoding. The output of the
following examples won't render correctly as your browser will be interpreting
this page as UTF-8:

{% highlight ruby %}
    str.encode!("Shift_JIS")
    => "���C���y�[�W"
    str.bytesize
    => 12

    str.encode!("EUC-JP")
    => "�ᥤ���ڡ���"
    str.bytesize
    => 12

    str.encode!("UTF-8")
    => "メインページ"
    str.bytesize
    => 18
{% endhighlight %}

If you try to encode a string into an encoding for which there are no
equivalent characters (ie. a UTF-8 string with Hebrew characters into
Shift-JIS), then a runtime exception will be raised.

To view the encodings available on the system:

{% highlight ruby %}
    Encoding.list
    => [#<Encoding:ASCII-8BIT>, #<Encoding:EUC-JP>, #<Encoding:Shift_JIS>, #<Encoding:UTF-8>, #<Encoding:ISO-2022-JP (dummy)>]
{% endhighlight %}

To set the default encoding to use in your scripts, use the following magic comment on the first line (or second if the first starts with #!):

{% highlight ruby %}
    # coding: utf-8
{% endhighlight %}

If you are reading in a file that is encoded differently to your default, you
can specify what to use when opening it:

{% highlight ruby %}
    File.open("/home/jh/downloads/UTF-8-demo.txt", "r:UTF-8") { |f| puts f.gets; puts f.gets; puts f.gets }
{% endhighlight %}

All this encoding sugar makes for a promising future for Ruby's international
support. I see it being useful in a few of the libraries I maintain to ensure
developers pass in strings with the correct encoding.

For a more detailed look at the encoding support in 1.9, I highly recommend to
chapter on encoding in the [3rd Edition of the
pickaxe](http://www.pragprog.com/titles/ruby3).
