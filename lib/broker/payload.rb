require 'ostruct'

module Broker
  class Payload
    
    attr_reader :pkg
    
    class << self
      
      def push(paths)
        paths.each { |p| parse(p) }
      end
    
      def parse(single_path)
        
        res = {
          file: single_path,
          dbid: nil,
          app: nil,
          table: nil
        }
        
        slots = single_path.split("/")
        slots.pop
        t = slots.pop
        a = slots.pop        
        
        _id = Broker.lookup_tbid({app: a, table: t})
        res[:dbid], res[:app], res[:table] = _id, Broker.lookup_appname(a), t
        
        new(res).enqueue
      end
      
      def chunk(arr)
        3.times { yield arr.pop }
      end
    end
    
    def initialize(opt={})
      @pkg = OpenStruct.new(file: opt[:file],
                            dbid: opt[:dbid],
                            app: opt[:app],
                            table: opt[:table])                  
    end
   
   
    def commit(session)
      results = session.fire_event(self)
      puts "#{results.inspect}"
    end

    def enqueue
     Broker.options[:enqueued] << self
    end
    
  end
end