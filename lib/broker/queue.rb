require 'broker/payload'

module Broker
  class Queue
    
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
    end
    
    def success(payload)
      @processed +=1
      move payload.pkg.file
    end
    
    private
    
    def move(filepath)
      # move file to processed location
    end
    
  end
end