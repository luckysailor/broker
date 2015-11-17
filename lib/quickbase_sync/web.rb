require 'erb'
require 'sinatra/base'

require 'quickbase_sync'

module QuickbaseSync
  class Web < Sinatra::Base
    
    set :root, File.expand_path(File.dirname(__FILE__) + "/../../web")
    set :public_folder, Proc.new { "#{root}/assets" }
    set :views, Proc.new { "#{root}/views" }
    
    DEFAULT_TABS = {
      "Dashboard" => '',
      "Imports"   => 'imports',
      "Exports"    => 'exports'
    }
    
    class << self
      def default_tabs
        DEFAULT_TABS
      end
    end
    
    get "/" do
      erb :index
    end
        
    
  end
end