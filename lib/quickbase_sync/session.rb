require 'quickbase_sync'
require 'quickbase_sync/client/quickbase_client'

module QuickbaseSync
  class Session
    
    attr_reader :client, :app
    
    def initialize(opt={})
      @app        = opt[:app]
      
      credentials = {
        "username" => QuickbaseSync.secrets['USER'],
        "password" => QuickbaseSync.secrets['PASSWORD'],
        "appname"  => @app,
        "org"      => QuickbaseSync.secrets['ORG'],
        "apptoken" => opt[:token] || QuickbaseSync.tables[@app]['token']
      }
      
      @client = QuickBase::Client.init(credentials)
    end
    
    def get_field_names(table)
      table &&= table.to_s
      db = QuickbaseSync.tables[@app]['tables'][table]
      db && @client.getFieldNames(db, "", true)
    end
    
    def sign_out
      @client.signOut
    end
    
  end
end