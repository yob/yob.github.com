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
