---
layout: post
---
We found an interesting bug in the FreeBSD 6.2 TCP stack at work this week. Full details are available in [this thread](http://lists.freebsd.org/pipermail/freebsd-net/2007-July/014780.html) on the freebsd-net mailing list, but essentially it caused the initial congestion window on the majority of connections to start at 1 segment size instead of 3 as recommended by RFC 3390.

With most hosts using delayed ACKs these days, a starting window of 1 segment means there will be a pause while the other end waits for a second packet or a timer expiry before sending an ACK. If the receiving host is FreeBSD the pause defaults to 100ms - it may differ on other systems.

For short flows (web, email, etc), 100ms is a significant amount of time for there to be no data transfer - particularly on a low RTT link like a LAN.

The bug was fixed a few months ago for FreeBSD 6.3 and 7.0, but from a quick check of the CVS logs it's existed since at least the 4.X days.
