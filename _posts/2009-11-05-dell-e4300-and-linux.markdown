---
layout: default
---
After 3.5 years of trusty service, it was time to retire my Dell Latitude D620.
It was out of warranty, wouldn't charge batteries and with a NVidia graphics
card it didn't play nice with Linux.

After considering my options (mac? lenovo?) I decided to stick with Dell. I've
used their Latitude line for some time and enjoy the ruggedness, backed by the
multi-year, next business day, onsite warranty. As a freelance web guy, it's
hard to beat having a tech visit you with 24 hours to fix a broken machine.

Wanting something slightly smaller than the D620, I settled on the [Latitude
E4300](http://www1.ap.dell.com/au/en/business/notebooks/laptop_latitude_e4300/pd.aspx?refid=laptop_latitude_e4300&s=bsd&cs=aubsd1).

I'm a Debian guy, and had no trouble installing the testing distrubution from
the netinstall CD, then dist-upgrading to unstable.

Hardware compatability is excellent - here's what lspci -nn tells me:

{% highlight sh %}
    [jh@gaz Desktop]$ lspci -nn
    00:00.0 Host bridge [0600]: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub [8086:2a40] (rev 07)
    00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a42] (rev 07)
    00:02.1 Display controller [0380]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a43] (rev 07)
    00:19.0 Ethernet controller [0200]: Intel Corporation 82567LM Gigabit Network Connection [8086:10f5] (rev 03)
    00:1a.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 [8086:2937] (rev 03)
    00:1a.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 [8086:2938] (rev 03)
    00:1a.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 [8086:2939] (rev 03)
    00:1a.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 [8086:293c] (rev 03)
    00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD Audio Controller [8086:293e] (rev 03)
    00:1c.0 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 [8086:2940] (rev 03)
    00:1c.1 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 [8086:2942] (rev 03)
    00:1c.3 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 [8086:2946] (rev 03)
    00:1d.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 [8086:2934] (rev 03)
    00:1d.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 [8086:2935] (rev 03)
    00:1d.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 [8086:2936] (rev 03)
    00:1d.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 [8086:293a] (rev 03)
    00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 93)
    00:1f.0 ISA bridge [0601]: Intel Corporation ICH9M-E LPC Interface Controller [8086:2917] (rev 03)
    00:1f.2 RAID bus controller [0104]: Intel Corporation Mobile 82801 SATA RAID Controller [8086:282a] (rev 03)
    00:1f.3 SMBus [0c05]: Intel Corporation 82801I (ICH9 Family) SMBus Controller [8086:2930] (rev 03)
    02:01.0 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C832 IEEE 1394 Controller [1180:0832] (rev 05)
    02:01.1 SD Host controller [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter [1180:0822] (rev 22)
    02:01.2 System peripheral [0880]: Ricoh Co Ltd R5C843 MMC Host Controller [1180:0843] (rev ff)
    0c:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 5300 AGN [Shiloh] Network Connection [8086:4235]
{% endhighlight %}

The following is a summary of major components and how they performed, along
with any work I had to perform to get them working. I was absolutely blown away
by how everything just worked. Linux compatability for Linux has come a long
way in the last 3 years.

### Display/Graphics

The Intel GS45 Express graphics card works fine in xorg with the
xserver-xorg-video-intel package. No /etc/X11/xorg.conf file is necesary.

Thanks to the open source intel drivers, xrandr 1.2 works really well.
Using a package like arandr, you can add or remove external monitors and change
resolutions, all without restarting X.

### Wired Ethernet

The 82567LM Intel gigabit network card works with the e1000 kernel driver.

### Wireless Network

The 5300 Intel wireless card works once the firmware-iwlwifi package has been installed.
This is a non-free package, make sure you have added non-free to your apt sources.

### Trackpad

The trackpad works under X with no customisations.

### Power

Suspend, resume and hibernate all work fine. A refreshing change after 3 years
of having no support for these at all. I suspect the binary NVidia drivers were
to blame, so I'm *more* than happy with my decision to get Intel hardware.

### Audio

Alsa audio worked with no customisations. I did need to unmute the default
channel.

### Firewire

The firewire port worked with no customisations.

### Kernel

I upgraded to the current kernel in Sid (2.6.31+22) with no issues.
