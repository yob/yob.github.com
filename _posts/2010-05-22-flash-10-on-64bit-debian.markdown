---
layout: post
---
Debian recently removed flash from their AMD64 to security issues and Adobe
dropping official support.

I dislike flash as much as the next self respecting web developer, but some
site (like google analytics) are pretty useless without it.

If you need a temporary solution to getting it up and running, manually download and install the old flash9 package from backports

{% highlight bash %}
    wget http://backports.mithril-linux.org/pool/contrib/f/flashplugin-nonfree/flashplugin-nonfree_1.4~bpo40+1_amd64.deb
    sudo dpkg -i flashplugin-nonfree_1.4~bpo40+1_amd64.deb
{% endhighlight %}

For further reading, check out the backports page for [flashplugin-nonfree](http://packages.debian.org/etch-backports/flashplugin-nonfree).

It's ye olde, but it works.
