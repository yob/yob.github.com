---
layout: default
title: Trusting New SSL Certificates in Debian
---

Debain (and Ubuntu) systems store a list of trusted Certificate Authority (CA)
SSL certificates in /etc/ssl/certs that many packages (ruby, curl, etc) rely
on.

These days, many SSL certificates are issued with at least 1 intermediate
certificate between the root CA certificate and the end of the chain. When the
intermediate certificate is unrecognised some SSL clients are happy to
automatically download them, but some will refuse to allow the connection to
continue.

Ruby throws an error when this happens and it looks something like this:

{% highlight bash %}
    SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
{% endhighlight %}

To resolve this, add the intermediate certificate to Debian's trusted set by
following these steps:

* Open the affected domain in a browser and view the intermediate certificate
* Export the certificate to a file with a .crt extension
* Copy the file to your Debian box and place it in /usr/local/share/ca-certificates
* As root, run `update-ca-certificates`

You should see output that looks something like this and any program that uses
Debian's central list of trusted certificates should be happy again.

{% highlight bash %}
    server:/usr/local/share/ca-certificates# cp /root/ThawteSSLCA.pem .
    server:/usr/local/share/ca-certificates# update-ca-certificates
    Updating certificates in /etc/ssl/certs...
    1 added, 0 removed; done.
    Running hooks in /etc/ca-certificates/update.d....done.
{% endhighlight %}
