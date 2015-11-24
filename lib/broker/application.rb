begin
  require File.expand_path('../../../config/initializers/broker', __FILE__)
rescue LoadError => e
  warn 'Could not load "initializers/broker"'
end

module Broker
  class Application

    def self.boot!      
      puts "starting up"
      puts "watching for files in #{Broker.options[:queue]}"
    end
    
  end    
end
