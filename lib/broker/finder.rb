require 'broker/payload'

module Broker
  class Finder
  
    def initialize
      opt = Broker.options
      @dir = File.join(opt[:queue], "**", "*.#{opt[:file_ext].to_s}")
    end

    def check
    	files = get
    	Broker::Payload.push(files) unless files.empty?
    end

    private

    def get
      Dir.glob(@dir)
    end
   
  end
end