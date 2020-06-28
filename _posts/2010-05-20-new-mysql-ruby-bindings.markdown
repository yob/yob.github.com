---
layout: post
---
There's been some recent discussions about the way ruby 1.9 handles encodings
and the exceptions people are running into, particularly when running rails.

A lot of the time, the exceptions are caused by database drivers passing back
multi-byte strings incorrectly tagged as ASCII-8BIT instead of UTF-8.

The work around was ususally to do something like the monkey patch described
[here](http://gnuu.org/2009/11/06/ruby19-rails-mysql-utf8/). I've used that
particular patch in production for a few months and it works fine, but monkey
patches make me squirm.

This week I was finally able to replace the patch with an alternative mysql gem
that retrieves all strings from the database as utf-8 and marks them correctly.

Brian Mario has released [mysql2](http://github.com/brianmario/mysql2). The
basic API is different to the standard mysql gem, but he's included an
ActiveRecord adapter that acts as a drop-in replacement for the mysql one.

To give mysql2 a go in rails install the gem:

{% highlight bash %}
    gem install mysql2
{% endhighlight %}

Then update your database.yml:

{% highlight yaml %}
    development:
      adapter: mysql2
      database: myapp_dev
      username: foo
      password: bar
      host: localhost
{% endhighlight %}

Make sure you get mysql2 version 0.1.6 or higher, in lower versions the
ActiveRecord adaptor behaved slightly differently from the default Mysql one.

Brian is incredibly responsive to bug reports, so if you have any issues make
sure you report them on the github project.
