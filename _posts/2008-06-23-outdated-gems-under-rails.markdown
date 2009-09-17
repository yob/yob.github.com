---
layout: default
---
I'm a fan of the new [gem dependency](http://railscasts.com/episodes/110)
feature added to Rails 2.1 and have started using it where possible.

Locking the app to a particular version is the right thing to do - loading the
most recent version is just asking for trouble. What happens when your
development and production boxes have different gem versions, or when the gem
maintainer introduces an API incompatible change?

I have a few apps in production though, and often forget what gem versions
I've locked the app to, and therefore don't realise when it's loading an out of
date version. An out of date gem isn't a huge issue, but there might be new 
features that are useful, or fixed bugs that I hadn't noticed.

I've put together a [little initializer](/files/check_gem_versions.rb) that checks all
the gems I've loaded when the rails app starts, and logs a notice to let me
know if it's out of date. It's non fatal - sometimes there are gems where I
want to be using an old version, but it's nice to be reminded that it might be
worth upgrading.

    # *************************************
    # A handy initilizer that logs when the loaded version of
    # Rails or a gem dependency is out of date. The notice is
    # non-fatal (often we want it to be out of date). I often
    # forget which version of a gem my apps are using, and 
    # don't notice when there is a newer version available.
    #
    # Only really makes sense on Rails >= 2.1, where initializers
    # and gem dependencies first appeared. Drop this file in
    # config/initializers/
    #
    # James Healy
    # 23rd June 2008
    # *************************************

    outdated = []

    # *************************************
    # check the current version of Rails to see if it's the latest
    # *************************************
    max_rails_gem = Gem.cache.search('rails').map(&:version).map(&:version).max

    if max_rails_gem && (Rails::VERSION::STRING < max_rails_gem)
      outdated << {:name => "rails", :loaded => Rails::VERSION::STRING, :max => max_rails_gem}
    end

    # *************************************
    # check the current version of all required gems to see if they're the latest
    # *************************************
    Rails.configuration.gems.each do |gem|
      name = gem.name
      loaded_version = gem.version.to_s
      max_gem_version = Gem.cache.search(name).map(&:version).map(&:version).max

      if max_gem_version && (loaded_version < max_gem_version)
        outdated << {:name => name, :loaded => loaded_version, :max => max_gem_version}
      end
    end

    # *************************************
    # print notices 
    # *************************************
    unless outdated.empty?
      logger = RAILS_DEFAULT_LOGGER
      logger.info 
      logger.info "*******************************"
      outdated.each do |w|
        logger.info "NOTICE: #{w[:name]} version #{w[:loaded]} is not the most recent version of rails available on the system (#{w[:max]})"
      end
      logger.info "*******************************"
      logger.info 
    end
