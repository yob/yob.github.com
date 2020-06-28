---
layout: post
---
Working for a company that sits in the middle of a supply chain, we deal with a
significant volume of data.

Inbound we have things like customer orders, new product data, invoices and
purchase order status reports from suppliers.

Outbound we have things like purchase orders going to our suppliers, order
confirmations, invoices and new product data going to our customers.

Most of this is electronic and automatic, and is therefore highly dependent on
industry standardised identifiers. In Australia, products are usually
identified with an
[EAN-13](http://en.wikipedia.org/wiki/European_Article_Number), but some of our
US based suppliers are still using
[UPC-12](http://en.wikipedia.org/wiki/Universal_Product_Code).

Australian businesses can be identified by their
[ABN](http://en.wikipedia.org/wiki/Australian_Business_Number), and in the book
industry there is a unique global ID system for businesses called
[SAN](http://www.isbn.org/standards/home/isbn/us/san/san-qa.asp).

To deal with all these IDs in my ruby code, I've put together some very simple
little gems for recognising and validating the various numbers I encounter.

    gem install ean13
    gem install upc
    gem install san
    gem install abn

They're all single file, single class libraries with similar looking APIs, and
operate in a similar way to the ISTC gem I talk about
[here](http://yob.id.au/blog/2008/10/22/istc/).

EAN13:

{% highlight ruby %}
    require 'ean13'

    EAN13.valid?("9781843549161")
    => true
    EAN13.complete("978184354916")
    => "9781843549161"
{% endhighlight %}

UPC:

{% highlight ruby %}
    require 'upc'
    
    UPC.valid?("028947663058")
    => true
    UPC.complete("02894766305")
    => "028947663058"
{% endhighlight %}

SAN: 

{% highlight ruby %}
    require 'san'

    SAN.valid?("9013725")
    => true
    SAN.complete("901372")
    => "9013725"
{% endhighlight %}

ABN:

{% highlight ruby %}
    require 'abn'

    ABN.valid?("12042168743")
    => true
{% endhighlight %}

Nothing groundbreaking or exciting, but useful little libraries when you need
to decipher what sort of identifier a number is, and for validating fields in
your models.
