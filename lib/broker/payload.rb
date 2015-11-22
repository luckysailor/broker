require 'ostruct'

module Broker
  class Payload
    
    attr_accessor :pkg, :results
    
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
      @response = nil
      @pkg = OpenStruct.new(file: opt[:file],
                            dbid: opt[:dbid],
                            app: opt[:app],
                            app_key: opt[:app_key],
                            table: opt[:table])                  
    end
   
    def commit(session)
      begin
        capture_response(session.fire_event(self))
      rescue => e
        # Need to log the failed attempt somewhere
        puts "#{pkg.file} failed to import!"
        puts e.message
        puts e.backtrace.join("\n")
        capture_response("Failed to Import")
        return nil
      end
      true
    end
    
    def capture_response(results)
      if results.respond_to?(:capitalize)
        @response = results
      else
        parse_response(results)
        puts "Captured Payload Result: #{@response.inspect}"
      end
    end
    
    # Quickbase API returns 2D array with results
    # First Element -> [num created, num imported, num updated, raw xml, update_id]
    # Second Element -> [invalid records that didn't get imported]
    
    def parse_response(results)
      details = results.shift
      res = {
        records_imported: details[1],
        records_created: details[0],
        records_updated: details[2],
        update_id: details[4],
        invalid_records: results.shift
      }
      @response = res
    end
    
  end
end