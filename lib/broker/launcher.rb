require 'broker/utility'

module Broker
  module Event
    def register(arr)
      unless arr.empty?
        while !Broker.options[:enqueued].empty?
          payload = Broker.options[:enqueued].shift
          puts "#{payload.pkg.file} processed"
        end
      end
    end
  end
  
  class Launcher
    
   def initialize
     @poller = Broker::Poller.new
     @finished = false     
   end
   
   def run
     puts "launcher is running"
     @poller.start
   end
   
   def stop
     @finished = true     
     @poller.terminate
     puts "launcher stopped"
   end 
    
  end
  
  class Poller
    include Utility
    include Broker::Event
    
    def initialize
      @finished  = false
      @wait_time = Broker.options[:poll_interval]
      @folder    = Broker.options[:queue]
      @finder		 = Broker::Finder.new
    end
    
    def terminate
      @finished = true
      if @thread
        t = @thread
        @thread = nil
        wait 1
        t.value
        puts "Polling thread terminated"
      end
    end
    
    def start
      @thread ||= safe_thread("poller") do 
        pause_first
        
        while !@finished
          register(@finder.check)
          wait
        end
      end
    end
    
    private
    
    def pause_first
      sleep 5
    end
    
    def wait(dur=nil)
      sleep dur || @wait_time
    end
  end
  
end