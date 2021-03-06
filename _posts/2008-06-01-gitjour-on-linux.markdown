---
layout: post
---
I just read about [gitjour](http://github.com/chad/gitjour/) over on the
[github blog](http://github.com/blog/75-git-over-bonjour), and naturally
instantly wanted to try out such a cool idea. A similar project for bazaar
[appeared earlier in the
year](http://blogs.gnome.org/jamesh/2008/02/19/bzr-avahi/). I've been itching
for a similar project for git ever since, but been too busy to look into it
myself.

Unfortunately it depends on the dnssd 0.6 gem, which was built for OSX and
requires a tiny bit of massaging to get working under linux.

Start by grabbing the dnssd 0.6 tarball from
[rubyforge](http://rubyforge.org/projects/dnssd/).

Unpack it, and apply this very [simple patch](dnssd_linux.diff).

    patch -p1 < dnssd_linux.diff

Compile (but don't install) the extension:

    ruby setup.rb config
    ruby setup.rb setup

Package the gem:

    gem build dnssd_osx.gemspec

If this fails, make sure you have the avahi libdnssd compatibility library
installed, and try again. On my Debian system, I needed the following 2
packages:

    aptitude install libavahi-compat-libdnssd1 libavahi-compat-libdnssd-dev

Essentially, dnssd binds to the Zeroconf/Bonjour library provided by Apple in
OSX. On Linux the standard library used for Zeroconf is Avahi, but it provides
a completely different API. The compatability layer lets Avahi pretend to be
Apple's Bonjour library.

Install the gem:

    gem install dnssd-0.6.0.gem

Now you should be right to install the gijour gem. You could clone their
repository on github if you like to live on the edge, but the code is in a
high state of change and seems to be broken at the moment.

    gem install gitjour

When using gitjour, you'll probably get a nice subtle warning about your use of
the dnssd compatibility layer, but it should till work.

    *** WARNING *** The program 'ruby1.8' uses the Apple Bonjour compatibility layer of Avahi.
    *** WARNING *** Please fix your application to use the native API of Avahi!
    *** WARNING *** For more information see <http://0pointer.de/avahi-compat?s=libdns_sd&e=ruby1.8>
