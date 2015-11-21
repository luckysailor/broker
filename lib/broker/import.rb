require 'broker/session'

module Broker
  class Import < Broker::Session
 
    def fire_event(payload)
      @payload = payload
      if qb_ready?(@payload.pkg.app_key) && respond_to?(ext)
        return send(ext)
      end
    end
    
    def csv
      @client.importCSVFile(@payload.pkg.file, @payload.pkg.dbid)
    end
    
    def txt
      @client.importTSVFile(@payload.pkg.file, @payload.pkg.dbid)
    end
 
  end
end