require 'broker/qb/session'

module Broker
  module QB
    class Import << Broker::QB::Session
   
      def fire_event(payload)
        @payload = payload
        send(ext) if self.respond_to? ext
      end
      
      def csv
        importCSVFile(@payload.file, @payload.dbid)
      end
      
      def txt
        importTSVFile(@payload.file, @payload.dbid)
      end
   
    end
  end
end