---
layout: post
---
[SCTP](http://www.sctp.org/) (Stream Control Transmission Protocol) is an alternative to TCP that has been in development for several years and is starting to draw some attention to itself.

Next week work is sending me on a 3 day SCTP training course and I've been having a poke at some sample code so I don't embarass myself when I get there. IBM has a [good introduction](http://www-128.ibm.com/developerworks/linux/library/l-sctp/index.html) with some C sample code that worked well enough on my linux 2.6.19 system. 

Being the ruby fanboi that I am, I then wanted to try opening an SCTP socket from a ruby script. Without going into SCTP implementation details, there are 2 ways of working with SCTP sockets - via the standard unix socket API, or using libsctp. The libsctp method provides superior functionality, however there don't seem to be any ruby bindings yet.

Using the unix sockets API, and inspiration from a useful [DCCP](http://en.wikipedia.org/wiki/Datagram_Congestion_Control_Protocol) [example](http://linux-net.osdl.org/index.php/DCCP), I got some simple SCTP test scripts going.

Server:

{% highlight ruby %}
    require "socket"

    # add some additional constants to the Socket class
    # to support SCTP
    class Socket
      IPPROTO_SCTP = 132
      SOL_SCTP = 132
    end

    # connection details
    SERVER = "127.0.0.1"
    PORT =  19000

    # start listening on a new socket
    server = Socket.new( Socket::AF_INET, Socket::SOCK_STREAM, Socket::IPPROTO_SCTP )
    sockaddr = Socket.pack_sockaddr_in( PORT, SERVER )
    server.bind(sockaddr)

    # wait for clients to connect
    while server.listen(1)
      # send some data to the client
      socket, client_addr = server.accept
      socket.puts "Test Data"

      # close the socket
      socket.close
    end
{% endhighlight %}

Client:

{% highlight ruby %}
    require "socket"

    # add some additional constants to the Socket class
    # to support SCTP
    class Socket
      IPPROTO_SCTP = 132
      SOL_SCTP = 132
    end

    # connection details
    SERVER = "127.0.0.1"
    PORT =  19000

    # open a new socket to the server
    client = Socket.new( Socket::AF_INET, Socket::SOCK_STREAM, Socket::IPPROTO_SCTP )
    sockaddr = Socket.pack_sockaddr_in( PORT, SERVER )
    client.connect(sockaddr)

    # receive any data the server spits back at us
    results = client.recv(1024)

    # print the results
    puts results.strip

    # close the socket
    client.close
{% endhighlight %}

To run the scripts, execute them using two terminals on the same machine. Under linux you will need to have the SCTP kernel module loaded, under FreeBSD i'm not sure what's required.

If you're familiar with using TCP sockets in ruby, you'll notice there's almost no difference. All I've done is use Socket::IPPROTO_SCTP instead of 0 for the third argument to Socket.new.

From a feature point of view, these scripts aren't particuarly better than using a TCP socket - to take full advantage of SCTP ruby will need libsctp bindings. Any volunteers?
