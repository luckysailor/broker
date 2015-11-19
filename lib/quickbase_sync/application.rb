
module QuickbaseSync
  class Application
    
    def self.boot!
      begin
        require 'config/initializers/quickbase_sync'
      rescue LoadError => e
        warn 'Could not load "initializers/quickbase_sync"'
      end
      puts "starting up"
      puts "watching for files in #{QuickbaseSync.queue}"
    end
    
  end
end