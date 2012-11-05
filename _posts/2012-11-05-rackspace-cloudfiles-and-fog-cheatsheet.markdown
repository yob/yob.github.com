---
layout: default
---

[Fog](http://rubygems.org/gems/fog) is an excellent rubygem for interacting
with [Rackspace Cloudfiles](http://www.rackspace.com/cloud/public/files/) but
somehow I can never remember the API details when I need them.

Here's a quick cheat sheet for fog 1.7.0 to help myself out next time.

## Initialisation

Everything starts with a storage instance

{% highlight ruby %}
    storage = Fog::Storage.new(:rackspace_username => 'RACKSPACE_USER',
                               :rackspace_api_key  => 'RACKSPACE_KEY',
                               :provider           => 'Rackspace')
{% endhighlight %}

## Retrieve Object Metadata

Use this to retrieve metadata about an object without downloading the content.

{% highlight ruby %}
    directory = storage.directories.get('CONTAINER_NAME')
    directory.files.head("path/menu.txt")
{% endhighlight %}

## Basic File Upload

Create a new object using data from a file.

{% highlight ruby %}
    directory = storage.directories.get('CONTAINER_NAME')

    File.open("/local/path/menu.txt", "rb") do |io|
      directory.files.create(:key  => "path/menu.txt",
                             :body => io)
    end
{% endhighlight %}

## Basic String Upload

Create a new object using data from a ruby string.

{% highlight ruby %}
    directory = storage.directories.get('CONTAINER_NAME')

    directory.files.create(:key  => "path/menu.txt",
                           :body => "Chunky Bacon")
{% endhighlight %}

## File Upload with Specific Headers

Create a new object and set some specific headers

{% highlight ruby %}
    headers = {
      "Content-Disposition" => 'attachment; filename="foo.txt"',
      "Content-Type"        => "text/plain"
      }
    File.open("/local/path/file.txt", "rb") do |io|
      storage.put_object("CONTAINER_NAME", "path/menu.txt", io, headers)
    end
{% endhighlight %}

## Temporary Objects

Create a new object that rackspace will automatically delete after one day.

{% highlight ruby %}
    headers = {
      "X-Delete-After" => 60 * 60 * 24
      }
    storage.put_object("CONTAINER_NAME", "path/menu.txt", "Chunky Bacon", headers)
{% endhighlight %}

## Deleting an Object

{% highlight ruby %}
    directory = storage.directories.get('CONTAINER_NAME')
    file      = directory.files.head("path/menu.txt")
    file.destroy if file
{% endhighlight %}

## Iterating Over a Large Container

If you have a container with thousands of objects, fog can handle iterating over
them all in a scalable way using each(). Behind the scenes it will retrieve
file metadata in batches of 1000.

Note that map() will appear to work but only returns the first 1000 objects.

{% highlight ruby %}
    directory = storage.directories.get('CONTAINER_NAME')
    directory.files.each do |file|
      puts file.inspect
    end
{% endhighlight %}

## Expiring URLs

Expiring URLs provide a means to share otherwise private files with another user
via a temporary HTTPS URL.

To begin using this feature, you will first need to set an account wide secret
key. ***WARNING*** changing this secret will invalidate any previous expiring
URLs.

{% highlight ruby %}
    storage.post_set_meta_temp_url_key('SECRET')
{% endhighlight %}

Once the secret is set, you must to instantiate your storage object with an extra
parameter.

{% highlight ruby %}
    storage = Fog::Storage.new(:rackspace_username     => 'RACKSPACE_USER',
                               :rackspace_api_key      => 'RACKSPACE_KEY',
                               :rackspace_temp_url_key => 'SECRET',
                               :provider               => 'Rackspace')
    storage.get_object_https_url('CONTAINER_NAME', "path/menu.txt", Time.now + 60)
{% endhighlight %}

## Copying Objects

Use this if you have an object already stored on cloud files and want to copy
it to another object. This is particularly useful if the file is large as it
avoids unnecessary downloading and uploading of the object data.

{% highlight ruby %}
    storage.copy_object("SOURCE_CONTAINER","source/key.txt","DEST_CONTAINER","dest/key.txt")
{% endhighlight %}

This is also useful if you want to change headers for an object, just use the
same source and destination to "copy" the file onto itself.

{% highlight ruby %}
    headers = {
      "Content-Disposition" => 'attachment; filename="foo.txt"',
      }
    storage.copy_object("SOURCE_CONTAINER","source/key.txt","SOURCE_CONTAINER","source/key.txt", headers)
{% endhighlight %}

There's no facility to move an object - if you need to move one, just copy it
then delete the original.
