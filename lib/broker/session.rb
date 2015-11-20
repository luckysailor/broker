
require 'broker/client/quickbase_client'

module Broker
  module QB
    class Session
      
      attr_reader :client, :app, :ext
    
      def initialize(opt={})
        @app = opt[:app]
        @ext = Broker.options[:file_ext]
      
        credentials = {
          "username" => Broker.secrets['USER'],
          "password" => Broker.secrets['PASSWORD'],
          "appname"  => @app,
          "org"      => Broker.secrets['ORG'],
          "apptoken" => opt[:token] || Broker.secrets['TOKEN']
        }
        
        begin
          @client = QuickBase::Client.init(credentials)
        rescue
          puts "Can't connect to Quickbase API"
        end
      end
      
      def sign_out
        @client.signOut
      end
      
      def app=(name)
        @app = name
      end
    
      def get_field_names(table)
        table &&= table.to_s
        db = Broker.tables[@app]['tables'][table]
        db && @client.getFieldNames(db, "", true)
      end
    
    end
  end
end