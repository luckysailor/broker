require 'broker/utility'
require 'broker/queue'

module Broker
  module Event
    def register(arr)
      
      unless arr.empty?
        begin
          @session = Broker::Import.new(:app => Broker.any_app)
        rescue ArgumentError => e
          @failed = true
          puts "Cant login to QB, invalid app name"
          puts e.message
        end
        @failed || transport
      end
      
    end
    
    def transport 
      while !@queue.empty?
        payload = @queue.next
        results = payload.commit(@session)
        puts "#{results.inspect}"
        @queue.success(payload)
        # Need to handle failure and add payload to queues failed
        # Need to handle success and move file out and alert queue
      end
      @session.sign_out
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
    include Event
    
    def initialize
      @finished  = false
      @wait_time = Broker.options[:poll_interval]
      @folder    = Broker.options[:queue]
      @queue     = Broker::Queue.new
      @finder		 = Broker::Finder.new(@queue)
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