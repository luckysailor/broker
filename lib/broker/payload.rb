require 'ostruct'

module Broker
  class Payload
    
    attr_reader :pkg
    
    class << self
    
      def parse(single_path)
        
        attrs = {
          file: single_path,
          dbid: nil,
          app: nil,
          app_key: nil,
          table: nil
        }
        
        # TODO: Rewrite!
        # Sloppy, need a more elegant way to pop values off the stack
        slots = single_path.split("/")
        slots.pop
        t = slots.pop
        a = slots.pop        
        
        _id = Broker.lookup_tbid({app: a, table: t})
        attrs[:dbid], attrs[:app], attrs[:app_key], attrs[:table] = _id, Broker.lookup_appname(a), a, t
        
        new(attrs)
      end
      
      def chunk(arr)
        3.times { yield arr.pop }
      end
    end
    
    def initialize(opt={})
      @pkg = OpenStruct.new(file: opt[:file],
                            dbid: opt[:dbid],
                            app: opt[:app],
                            app_key: opt[:app_key],
                            table: opt[:table])                  
    end
   
    def commit(session)
      session.fire_event(self)
    end
    
  end
end