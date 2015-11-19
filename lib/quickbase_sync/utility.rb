module QuickbaseSync
  module Utility
   
   def watchdog(last_words)
     yield
   rescue Exception => ex
     raise ex
   end
   
   def safe_thread(name, &block)
     Thread.new do
       watchdog(name, &block)
     end
   end
    
  end
end