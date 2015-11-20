module QuickbaseSync
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
    
  end
end