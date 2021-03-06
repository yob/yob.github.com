---
layout: post
---
Last night I found myself a long way from an Internet connection and needing to
check my email. I thought I'd finally try using my mobile phone (a 2 year old
Sony Ericsson k610i) as a modem as 3G had recently been enabled in the area. My
laptop is running Debian unstable with a 2.6.25 kernel.

I plugged the phone in with its USB cable, and noticed 2 serial ports come up.
A [tutorial
page](http://c0dejammer.wordpress.com/2008/05/06/t-mobile-webnwalk-on-debian-sid-sidux-with-k610i/)
I'd saved during an earlier research session gave me some tips on using one of
the serial ports to establish a PPP connection. It nearly worked as advertised
- the phone connected to the Internet, my PPP sessions got an IP address, and I
  could make DNS lookups. Unfortunately I couldn't seem to get any other type
  of traffic to work. My TCP SYN packets went unanswered.

After 30 minutes or so of debugging, I tried a new option in the phone menu:

Settings
  -> Connectivity
    -> USB
      -> USB Internet
        -> Turn On

As soon as I enabled that, my laptop discovered a new USB ethernet device.
Seconds after that, I had a global IP address and was happily browsing the net -
no PPP connection required.

Now if only the data rates from my phone company weren't so excessive....
