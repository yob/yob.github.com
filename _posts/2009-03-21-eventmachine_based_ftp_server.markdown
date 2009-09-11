### The short version

I've released a demo of an FTP server for ruby, built on the EventMachine library.

Check it out here: [http://github.com/yob/em-ftpd/tree](http://github.com/yob/em-ftpd/tree)

### The full version

Inside our little web 2.0 bubble we all get very excited about shiny things
like REST, web services and open JSON APIs, so it's easy to forget in the
business world with many trading partners and legacy systems, a technology that
works tends to hang around for an awfully long time.

In the supply chain world, the most common way I've encountered for electronic
trading between businesses (submitting orders, receiving invoices, etc) is over
good 'ole [FTP](http://tools.ietf.org/rfc/rfc959.txt).

Yes, it's old and insecure. However it's also simple, well understood, has
plenty of library support and is now embedded in inventory management software
all over the place. You work with what you've got.

For a few years I've maintained a custom FTP server for a client. It accepts
uploaded orders from their customers, translates them to a format the clients
system can understand and saves a copy to a outbox folder. Every few hours the
clients inventory software connects and downloads the orders directly into
their system. It's hardly a high traffic site, maybe 20 transfers a day, all
small text files.

The server was a small ruby daemon, based on the
[ftpd.rb](http://rubyforge.org/projects/ftpd/) script published by Chris
Wanstrath, and it performed admirably. Recently I was asked to add some new
features, and I realised over the years the code had turned into 800 lines of
spaghetti. A rewrite was in order.

At the same time a few fellow Australian Rubyist's had been [playing
around](http://gist.github.com/81523/) with
[EventMachine](http://rubyeventmachine.com/), a library that claims to help
produce highly scalable network code. Scalability wasn't my issue, but the
examples I could see looked alarmingly clean and simple for network socket
based applications. Best of all, there was no need to involve threads, the arch
nemesis of maintainable code.

Clean and simple was the goal of my rewrite. Bingo.

It took a little while to come to a working solution, mainly because I found
few public EventMachine samples that indicated how to open multiple sockets and
share data between them. It turned out to be possible and my rewritten server
went into production a few days ago.

There was no point asking this client to release their new server as open
source, it's fairly specific to their needs. However I was keen to provide a
public demo of an EventMachine based FTP server, so I've published a new
demo script on github:
[http://github.com/yob/em-ftpd/tree](http://github.com/yob/em-ftpd/tree)

It's not particularly useful as a real FTP server - it hard codes the
authentication tokens and provides a simulated directory structure. Hopefully
it proves interesting or useful to someone out there though - as a basis for their
own custom FTP server or some other multi-socket protocol.
