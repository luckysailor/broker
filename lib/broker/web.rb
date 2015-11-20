require 'erb'
require 'sinatra/base'

require 'broker/web_helpers'
require 'broker/web_routes'


module Broker
  class Web < Sinatra::Base
    
    set :root, File.expand_path(File.dirname(__FILE__) + "/../../web")
    set :public_folder, Proc.new { "#{root}/assets" }
    set :views, Proc.new { "#{root}/views" }
    
    helpers WebHelpers
    
    register Broker::WebRoutes
    
    DEFAULT_TABS = {
      "Dashboard" => '',
      "Imports"   => 'imports',
      "Exports"   => 'exports',
      "API"       => 'api'
    }
    
    class << self
      def default_tabs
        DEFAULT_TABS
      end
    end
        
  end
end