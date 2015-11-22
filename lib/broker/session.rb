require 'broker/client/quickbase_client'

module Broker
  class Session
    
    attr_reader :client, :app, :ext
  
    def initialize(opt={})
      @app = Broker.lookup_appname(opt[:app])
      @ext = Broker.options[:file_ext]
    
      credentials = {
        "username" => Broker.secrets['USERNAME'],
        "password" => Broker.secrets['PASSWORD'],
        "appname"  => @app,
        "org"      => Broker.secrets['ORG'],
        "apptoken" => opt[:token] || Broker.secrets['TOKEN']
      }
      
      begin
        @client = QuickBase::Client.init(credentials)
      rescue => e
        puts e.message
        #raise ArgumentError
      ensure
        # We successfully logged into quickbase, but supplied an invalid app name
        if @client && @client.errcode == "32"
          @client.signOut
          raise ArgumentError
        end
      end
    end
    
    def fire_event
      raise NotImplementedError
    end
    
    def sign_out
      @client.signOut
    end
    
    def qb_ready?(name)
      app_name = Broker.lookup_appname(name)
      unless app_name == @client.dbname
        return app_name && change_app(app_name, name)
      end
      true
    end
  
    def field_names(table)
      table &&= table.to_s
      db = Broker.tables[@app]['tables'][table]
      db && @client.getFieldNames(db, "", true)
    end
    
    private
    
    def change_app(app_name, app_key)
      @app = app_key.to_s
      @client.findDBByname(app_name)
      @client.dbname == app_name
    end
  end
end