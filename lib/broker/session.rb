require 'broker'
require 'broker/client/quickbase_client'

module Broker
  class Session
    
    attr_reader :client, :app
    
    def initialize(opt={})
      @app        = opt[:app]
      
      credentials = {
        "username" => Broker.secrets['USER'],
        "password" => Broker.secrets['PASSWORD'],
        "appname"  => @app,
        "org"      => Broker.secrets['ORG'],
        "apptoken" => opt[:token] || Broker.tables[@app]['token']
      }
      
      @client = QuickBase::Client.init(credentials)
    end
    
    def get_field_names(table)
      table &&= table.to_s
      db = Broker.tables[@app]['tables'][table]
      db && @client.getFieldNames(db, "", true)
    end
    
    def sign_out
      @client.signOut
    end
    
  end
end