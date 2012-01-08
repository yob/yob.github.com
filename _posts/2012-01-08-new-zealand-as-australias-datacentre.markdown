---
layout: default
title: New Zealand as Australia's Data Centre?
---
Like many rubyists I've often used [Slicehost](http://www.slicehost.com) to
host my virtual servers.

As a networking nerd who cares about latency (see [It's the Latency
Stupid](http://rescomp.stanford.edu/~cheshire/rants/Latency.html) ) I've always
wanted to host my client sites in Australia, however data prices here made it
prohibitively expensive. Slicehost in the States was often the next best option.

Some time ago they were purchased by [Rackspace](http://www.rackspace.com) and
they're finally preparing to migrate everyone to the Rackspace cloud platform.

I was happy enough with the migration, however it prompted me to do a quick
scan of other options and I found something surprising. I can run a VPS at
[Rimuhosting's](http://rimuosting.com) Auckland data centre for about the same
price as their US datacentre and it's only a 50ms RTT from Melbourne.

It's not unusual to find data costs with Australian VPS providers (including
Rimu) hovering around AUD$2/Gb. At rimuhosting's Auckland datacentre it's
NZD$0.20/Gb (currently about AUD$0.15).

What's going on here? Are data prices in New Zealand cheaper than Australia? Is
Rimuhosting oversubscribing their transit links? Are they buying budget
transit? Are other New Zealand companies cheaper than their Australian
competitors or is this an edge case?

Whatever the reason, I moved a clients VPS from the US to Auckland two weeks
ago and couldn't be happier with the result.
