begin
  require File.expand_path('../../../config/initializers/quickbase_sync', __FILE__)
rescue LoadError => e
  warn 'Could not load "initializers/quickbase_sync"'
end

module QuickbaseSync
  class Application
    
    def self.boot!      
      puts "starting up"
      puts "watching for files in #{QuickbaseSync.queue}"
    end
    
  end
end