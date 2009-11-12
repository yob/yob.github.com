---
layout: default
---
For a couple of years I've been involved in various PDF related Ruby projects -
most recently in [prawn](http://prawn.majesticseacreature.com/), a pure ruby
PDF generation library.

Prawn is a long way from implementing all parts of the spec and there has been
no shortage of people who desire support for various features. The biggest
barrier in getting new features has been the core developers have limited time.

Many of these users are the kind who will submit a patch to an open source when
they find a missing feature, yet this has only happened to prawn in a small
number of cases.

The PDF spec is epic (version 1.7 is over 1300 pages), yet the basic structure
is less complicated than it first appears. There's a fair amount of assumed
knowledge to wade through, but I figure if I provide a basic overview of the
file structure that's one less thing for potential prawn contributors to work
out on their own.

I've generated a [simple PDF](/files/hexagon.pdf) to use as an example.

The best way to think of the file is a series of objects (strings, hashes,
symbols, integers, arrays, etc) in an object tree. In the general case, every
object in the file will be accessible from an object tree that descends from a
single hash.

To start navigating the file by eye, open it in a text editor and browse to the
last line. Just above the end of the file token (%%EOF) is a number that
indicates a byte offset in the file.

That byte offset points to the "xref" token on line 46. "0 6" indicates that
this file has 5 objects in it numbered 1-5 (plus a number 0 null object). The
following lines indicate object 1 is at byte offset 15, object 2 at offset 71,
etc.

After the byte offsets you'll see the following lines:

{% highlight ruby %}
    << /Info 1 0 R
    /Size 6
    /Root 3 0 R
    >>
{% endhighlight %}

This is called the trailer and it is a serialised hashmap. In Ruby syntax, this
would look something like:

{% highlight ruby %}
    { :Info => 1 0 R, :Size => 6, :Root => 3 0 R }
{% endhighlight %}

This is the top of our object tree. "1 0 R" is the syntax for pointing to
object #1. Using our xref table we can see object 1 is at byte 17 and it looks
like this:

{% highlight ruby %}
    << /Creator (Prawn)
    /Producer (Prawn)
    >>
{% endhighlight %}

It's another hash that looks like this in Ruby:

{% highlight ruby %}
    { :Creator => "Prawn", :Producer => "Prawn" }
{% endhighlight %}

Merge this with our trailer hash and our object tree now looks like:

{% highlight ruby %}
    {
      :Info => { :Creator => "Prawn", :Producer => "Prawn" },
      :Size => 6,
      :Root => 3 0 R
    }
{% endhighlight %}

Repeat this process for every time you see "n 0 R" (called an indirect object)
and you will have a complete PDF object graph.

Prawn's job is to do the reverse - build an object graph that conforms to the spec and
serialise it to a file in the correct format. Prawn has all the tools for
serialising standard ruby objects into their PDF representation, so the trick is
to find the correct place to add your new information (an extra font, an
advanced colour definition, whatever) and insert it as a ruby object. Usually
this means something adding an entry to an array or hash.

Once that's done, prawn will handle the serialisation when a user calls render.
