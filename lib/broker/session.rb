require 'broker/client/quickbase_client'

module Broker
 # module QB
    class Session
      
      attr_reader :client, :app, :ext
    
      def initialize(opt={})
        @app = opt[:app]
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
        end
      end
      
      def sign_out
        @client.signOut
      end
      
      def change_app_to(name)
        app_name = Broker.lookup_appname(name)
        app_name && make_change(app_name, name)
      end
    
      def get_field_names(table)
        table &&= table.to_s
        db = Broker.tables[@app]['tables'][table]
        db && @client.getFieldNames(db, "", true)
      end
      
      private
      
      def make_change(app_name, app_key)
        @app = app_key.to_s
        @client.findDBByname(app_name)
        @client.dbname == app_name
      end
    end
 # end
end