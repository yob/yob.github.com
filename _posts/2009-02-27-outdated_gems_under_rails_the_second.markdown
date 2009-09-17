---
layout: default
---
Last year I [shared a short initialiser fragment](/blog/2008/06/23/outdated_gems_under_rails)
for rails that warns you if you've loaded an out of date gem.

It's a non fatal warning, just a reminder that it might be worthwhile upgrading.

I still use the fragment, but have updated it to support rails 2.2+. To use it,
just drop the code into a file in the config/initializers directory of your
app.

    # *************************************
    # A handy initiliser that logs when the loaded version of
    # Rails or a gem dependency is out of date. The notice is
    # non-fatal (often we want it to be out of date). I often
    # forget which version of a gem my apps are using, and 
    # don't notice when there is a newer version available.
    #
    # Only really makes sense on Rails >= 2.1, where initialisers
    # and gem dependencies first appeared. Drop this file in
    # config/initializers/
    #
    # James Healy
    # 2nd Feb 2009
    # *************************************

    outdated = []

    # *************************************
    # check the current version of Rails to see if it's the latest
    # *************************************
    max_rails_gem = Gem.cache.find_name('rails').map(&:version).map(&:version).max

    if max_rails_gem && (Rails::VERSION::STRING < max_rails_gem)
      outdated << {:name => "rails", :loaded => Rails::VERSION::STRING, :max => max_rails_gem}
    end

    # *************************************
    # check the current version of all required gems to see if they're the latest
    # *************************************
    Rails.configuration.gems.each do |gem|
      name = gem.name
      if Rails::VERSION::STRING >= "2.2.0"
        loaded_version = gem.specification.version.to_s
      else
        loaded_version = gem.version.to_s
      end
      max_gem_version = Gem.cache.find_name(name).map(&:version).map(&:version).max

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
        logger.info "NOTICE: #{w[:name]} version #{w[:loaded]} is not the most recent version of #{w[:name]} available on the system (#{w[:max]})"
      end
      logger.info "*******************************"
      logger.info 
    end
