require 'broker/payload'
require 'broker/utility'

module Broker
  class Queue
    include Broker::Utility
    
    attr_reader :processed, :pending, :failed
    
    def initialize
      @processed = 0
      @pending = []
      @failed = []
    end
    
    def push(paths)
      paths.each { |p| @pending << Broker::Payload.parse(p) }
    end
    
    def next
      @pending.pop
    end
    
    def empty?
      @pending.empty?
    end
    
    def failure(payload)
      @failed << payload
      move(payload, Broker.options[:failed_path])
    end
    
    def success(payload)
      @processed +=1
      move(payload, Broker.options[:processed_path])
    end
    
    private
    
    def move(payload, dest)
      f = "#{timestamp}_#{File.basename(payload.pkg.file)}"
      FileUtils.mv payload.pkg.file, File.join(dest, "/", f)
    end
    
  end
end