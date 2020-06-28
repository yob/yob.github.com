---
layout: post
title: "Inflating zlib, gzip and deflate in Ruby"
---

[zlib](https://zlib.net/) is a C library that can (de)compress data in three formats:

1. raw DEFLATE streams, as documented in [RFC1951](https://tools.ietf.org/html/rfc1951)
2. zlib streams, as documened in
   [RFC1950](https://tools.ietf.org/html/rfc1950). These are a DEFLATE stream,
   with a 2-byte header prefix and 4-byte footer suffix
3. gzip streams, as documented in
   [RFC1952](https://tools.ietf.org/html/rfc1952). These are a DEFLATE stream,
   with a header prefix slightly larger than 2-bytes.

The RFCs were published in the mid 1990s, and the DEFLATE format pre-dates them
by a few years. These formats (particularly RFC1952 gzip streams) are **super**
common, thanks to being utilised in various subsequent internet standards (like
HTTP).

The ruby standard library conveniently includes bindings, and decompressing all
three formats is quick:

{% highlight ruby %}
    require 'zlib'
    puts Zlib::Inflate.new(WINDOW_BITS).inflate(data)
{% endhighlight %}

The internet is full of suggestions for the correct `WINDOW_BITS` magic number
in various situations, but how do you pick the right one (other than just
trying them all until one works)?

{% highlight ruby %}
    require 'zlib'
    
    # raw deflate, no header or footer 
    rfc1951_data = File.read("hello-world.deflate")
    
    # zlib container, 2 byte header, 4 byte adler footer
    rfc1950_data = File.read("hello-world.z")
    
    # gzip container
    rfc1952_data = File.read("hello-world.gz")
    
    RAW_DEFLATE              = -15 # Zlib::MAX_WBITS * -1
    AUTO_DETECT_ZLIB_OR_GZIP = 47  # Zlib::MAX_WBITS + 32
    GZIP_ONLY                = 31  # Zlib::MAX_WBITS + 16
    
    # By default, Zlib::Inflate will inflate an RFC1950 zlib stream
    puts Zlib::Inflate.new.inflate(rfc1950_data)
    
    # A MAGIC_NUMBER of 31 will inflate a gzip stream
    puts Zlib::Inflate.new(GZIP_ONLY).inflate(rfc1952_data)
    
    # A MAGIC_NUMBER of 47 will auto-detect both zlib and gzip streams and
    # inflate both. Useful!
    puts Zlib::Inflate.new(AUTO_DETECT_ZLIB_OR_GZIP).inflate(rfc1950_data)
    puts Zlib::Inflate.new(AUTO_DETECT_ZLIB_OR_GZIP).inflate(rfc1952_data)
    
    # A MAGIC_NUMBER of -15 will inflate a raw DEFLATE stream.
    puts Zlib::Inflate.new(RAW_DEFLATE).inflate(rfc1951_data)
    
    # Combining these options into a single method allows inflating all
    # three formats
    def inflate(data)
      Zlib::Inflate.new(AUTO_DETECT_ZLIB_OR_GZIP).inflate(data)
    rescue Zlib::DataError
      Zlib::Inflate.new(RAW_DEFLATE).inflate(data)
    end
    
    puts inflate(rfc1951_data)
    puts inflate(rfc1952_data)
    puts inflate(rfc1950_data)
{% endhighlight %}

Why the magic numbers?

`WINDOW_BITS` is intended to indicate the size of the window zlib should use,
where the window is equal to 2^WINDOW_BITS bytes. The window can be 256 - 32,768 bytes
(32Kb), so the normal range of `WINDOW_BITS` is 8-15. In practice with the
memory we have in 2020 computers, 15 is the most common value.

It seems the zlib authors have overloaded the argument, allowing us to request
extra behaviour by using numbers outside the range that makes sense for
windows.

... and what is a window anyway?

When deflating, a larger window instructs zlib to search a larger area of the
plaintext (up to 32Kb backwards) for repeated patterns. A larger window will
result in better compression, at the cost of more memory consumption. In
practice with the memory we have in 2020 computers, 32Kb is tiny and
`WINDOW_BITS` of 15 is the default value.

When inflating, manually setting the window size isn't very useful. Inflating
requires a window at least as large as the one used to deflate a stream, and
the default behaviour of always allocating 32Kb is rarely a problem. Setting
`WINDOW_BITS` to a value outside the 8-15 range to specify formats is likely
the only time you'll need to use it.

## Example Files

1. [hello-world.deflate](/files/hello-world.deflate) - raw DEFLATE stream (RFC1951)
2. [hello-world.z](/files/hello-world.z) - zlib stream (RFC1950)
3. [hello-world.gz](/files/hello-world.gz) - gzip stream (RFC1952)
