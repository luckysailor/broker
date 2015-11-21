require 'broker/queue'

module Broker
  class Finder
  
    def initialize(q)
      opt = Broker.options
      @queue = q
      @dir = File.join(opt[:queue], "**", "*.#{opt[:file_ext].to_s}")
    end

    def check
    	files = get
    	@queue.push(files) unless files.empty?
    end

    private

    def get
      Dir.glob(@dir)
    end
   
  end
end