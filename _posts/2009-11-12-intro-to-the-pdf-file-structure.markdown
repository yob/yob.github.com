---
layout: default
---
For a couple of years I've been involved in various PDF related Ruby projects -
most recently in [prawn](http://prawn.majesticseacreature.com/), a pure ruby
PDF generation library.

Prawn is a long way from implementing all parts of the spec and there has been
no shortage of people who desire support for various features. Many of these
users are the kind who will submit a patch to an open source project when they
find a missing feature, yet this has only happened to prawn in a small number
of cases.

The PDF spec is epic (version 1.7 is over 1300 pages), yet the basic structure
is less complicated than it first appears. Don't be put off! We'd love more
contributors to prawn, so this post is intended to be a basic introduction to
reading a PDF file - the first step in understanding how prawn does the reverse
process.  I've created a [simple PDF](/files/hexagon.pdf) to use as an example.

The best way to think of the file is a set of objects (strings, hashes,
symbols, integers, arrays, etc) in a single object tree that descends from a
single "root" hash.

To start navigating the [example file](/files/hexagon.pdf) by eye, open it in a
text editor and browse to the last line. Just above the end of the file token
(%%EOF) is a number that indicates a byte offset in the file.

That byte offset points to the "xref" token on line 46. Everything between here
and the "trailer" token several lines below is called the Cross Reference Table
(xref table to its friends). "0 6" indicates that this file has 5 objects in it
numbered 1-5 (plus a number 0 null object). The following lines indicate object
1 is at byte offset 15, object 2 at offset 71, etc.

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
    {
      :Info => "1 0 R",
      :Size => 6,
      :Root => "3 0 R"
    }
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
      :Root => "3 0 R"
    }
{% endhighlight %}

Repeat this process for every time you see "n 0 R" (called an indirect object)
and you will have a complete PDF object graph.

Prawn's job is to do the reverse - build an object graph that conforms to the spec and
serialise it to a file in the correct format. Prawn has all the tools for
serialising standard ruby objects into their PDF representation, so the trick is
to find the correct place to add your new information (an extra font, an
advanced colour definition, whatever) and insert it as a ruby object. Usually
this means something like adding an entry to an array or hash.

Once that's done, prawn will handle the serialisation when a user calls render.

For homework, download a copy of the [PDF
spec](http://www.adobe.com/devnet/acrobat/pdfs/PDF32000_2008.pdf) and read
chapter 7 (particularly sections 7.3, 7.5, 7.7, 7.8 and 7.9). Also check out
[lib/prawn/pdf_object.rb](http://github.com/sandal/prawn/blob/4b7f1a4d975b3478dad184bd56c7f53e7d92b784/lib/prawn/pdf_object.rb)
to see how prawn converts each Ruby object into PDF equivalents.
