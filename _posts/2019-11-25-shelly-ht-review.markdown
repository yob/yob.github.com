---
layout: post
title: "Review: Shelly H&T Temperature Sensor"
---

I feel too time poor to invest in home automation, however some basic
monitoring of temperature might help us manually keep the house comfortable for
a modest investment of time (and money).

For each room of the house, I'm keen to know the temperature at which we felt
comfortable and how hard we had to run the heating (and cooling) to stay in
that range.

One way to achieve that is the [Shelly
H&T](https://shelly.cloud/shelly-humidity-and-temperature/), a wifi humidity
and temperature sensor. By default it's battery powered (a single CR123A), but
an optional [micro USB
power](https://shelly.cloud/product/usb-power-supply-for-shelly-ht/) add-on is
available.

![ht](/images/shelly-ht.jpg)

It's incredibly small, but unfortunately it's not cheap. For one unit with a
USB add-on I paid EUR28.98, plus EUR5.55 shipping. Around AUD$55 all up.

It works as advertised, however after trying it for a few weeks I've decided to
look for another solution.

The wifi connectivity is certainly convenient. After setup, it connected
directly to my local wifi and started submitting data to Shelly's cloud
servers. The data is available via an API or phone app. Connecting IOT devices
to the Internet makes me nervous, so I then took advantage of the option to
disable internet connectivity and had the sensor values reported to a local
MQTT server instead. 

The battery is reported to only last a few months - I'm guessing the wifi chip
is power hungry. The USB add-on solves that issue, but if I were to use one in
each room of the house I'd take up plenty of power sockets.

Apparently if the system is on continuously it can heat up and cause inflated
temperature reads, so it goes to sleep and wakes up periodically to report a
reading (either to Shelly or via MQTT). This is understandable, but it was
disappointing to only get a sensor read every 10 minutes. 

If you were using other devices in the Shelly ecosystem the H&T may be a good
option. It integrates smoothly with their ecosystem, and can easily trigger
other Shelly devices (like relays, lights and "smart" plugs).

However, I'm not using other Shelly devices so I'll keep looking for something
with decent battery life that provides more frequent sensor reads. Hopefully
that magical device exists.
