Until recently, I was a happy occasional user of a coworkers Telstra NextG card
on my Linux (Debian Unstable) laptop, thanks to this very [accurate
guide](http://quozl.linux.org.au/bp3-usb/). The card I'm using is a PCCARD,
Sierra Wireless Aircard 875, but the basic principles in that guide still apply.

When you insert the card, 3 serial ports should be added to the machine:

* /dev/ttyUSB0 - the port to open the ppp connection over
* /dev/ttyUSB1 - for propriety command and control access, currently unsupported and unneeded.
* /dev/ttyUSB2 - command and control port that accepts standard AT commands

The connection software my co-worker uses with the card in Windows recently prompted him
to update the firmware to get snazzy 7.5mbs downlink speeds. Unfortunately it also seemed
to change the initialisation procedures for the card, preventing my previously
fine setup under Linux from working. The radio is no longer enabled by default,
so no ppp connection on ttyUSB0 was possible.

To enable the radio, connect to ttyUSB2 with a serial terminal (like gtkTerm), and run the
following command:

    at+cfun=1

This should enable the blue radio light on the card, and turn the 3g light to orange, which 
indicates it is connected to the network, but not authenticated.

To check the card status, use:

    at!gstatus?

And to check the signal strength, use (a value of 7 or more should be adequate):

    at+csq

The guide above suggests using the phone number "\*99#" to connect. This generally
is fine, as it selects the default profile. Unfortunately the firmware upgrade also moves
the telstra settings to profile 2. To view both profiles, use: 

    at+cgdcont?

Check the APN value for profile 2, and setup profile 1 using something like:

    at+cgdcont=1,"IP","telstra.bigpond"

It's possible your APN will be something other than telstra.bigpond, so make sure you copy the 
correct value from profile 2.

With all that done, the guide by Quozl should work as expected.

## Further Reading

Most of this information was gleamed from [a guide](http://www.sierrawireless.com/faq/ShowFAQ.aspx?ID=1087) available on the Sierra website
