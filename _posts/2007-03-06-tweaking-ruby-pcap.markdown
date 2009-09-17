---
layout: default
---
[Ruby/Pcap](http://www.goto.info.waseda.ac.jp/~fukusima/ruby/pcap-e.html) provides ruby bindings to the libpcap c library, making packet dumping and analysis relatively easy. There's a handful of tutorials around that provide some basic examples however I ran into a few problems when using the bindings at work.

Unfortunately, they haven't been updated in a long time and I was getting some warnings due to deprecated code.

    pcap.so: warning: do not use Fixnums as Symbols

I found a site in Japanese that seemed to [explain the warning](http://devlog.moonwolf.com/200410.html) ([google cache version](http://72.14.253.104/search?q=cache:FVV1GK2aUpgJ:devlog.moonwolf.com/200410.html+%22do+not+use+fixnums+as+symbols%22+pcap&hl=en&client=firefox-a&strip=1)), and managed to infer the solution to making the warnings go away.

Find the following lines in Pcap.c:

{% highlight c %}
    cPcapStat = rbfuncall(rbcStruct, rb_intern("new"), 4,
      Qnil,
      INT2NUM(rb_intern("recv")),
      INT2NUM(rb_intern("drop")),
      INT2NUM(rb_intern("ifdrop")));
{% endhighlight %}

and change them to:

{% highlight c %}
    cPcapStat = rbfuncall(rbcStruct, rb_intern("new"), 4,
      Qnil,
      ID2SYM(rb_intern("recv")),
      ID2SYM(rb_intern("drop")),
      ID2SYM(rb_intern("ifdrop")));
{% endhighlight %}

then recompile and reinstall the bindings:

    make
    make install
