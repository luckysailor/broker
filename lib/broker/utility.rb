module Broker
  module Utility
   
   def watcher(last_words)
     yield
   rescue Exception => ex
     raise ex
   end
   
   def safe_thread(name, &block)
     Thread.new do
       watcher(name, &block)
     end
   end
   
   def timestamp
     Time.now.strftime("%Y-%m-%dT%H.%M.%S")
   end
    
  end
end