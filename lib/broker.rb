require 'broker/version'
#require 'broker/session'
require 'yaml'

module Broker
  NAME = "Broker"
  
  DEFAULTS = {
    secrets_path: 'config/secrets.yml',
    tables_path: 'config/quickbase_tables.yml',
    initializer: 'config/initializers/broker.rb',
    poll_interval: 300,
    queue: 'broker_queue',
    processed_path: 'broker_processed',
    failed_path: 'broker_failed',
    file_ext: :csv,
    enqueued: []
  }
  
  def self.load_config(dest)
    YAML.load_file(dest) rescue {}
  end
  
  @@secrets = @@secrets ||= load_config(DEFAULTS[:secrets_path])
  @@tables  = @@tables  ||= load_config(DEFAULTS[:tables_path])
  
  def self.options
    @options ||= DEFAULTS.dup
  end
  
  def self.lookup_tbid(opt={})
    tables[opt[:app]]['tables'][opt[:table]]
  end
  
  def self.lookup_appname(key)
    tables[key.to_s]['name']
  end
  
  def self.path
    Dir.pwd
  end
  
  def self.setup
    yield self unless launched?
  end
  
  def self.launched?
    defined?(Broker::Launcher)
  end
  
  def self.config_files
    fs = [:secrets_path, :tables_path, :initializer]
    options.select { |opt| fs.include? opt }.values
  end
  
  def self.secrets
    @@secrets
  end
  
  def self.tables
    @@tables
  end
  
  def self.table_keys
    tables.keys
  end
  
  def self.any_app
    table_keys.first
  end
  
  # Initializer setter methods
  # Loaded at runtime in initializers/broker.rb
  # Broker.setup do |config|
  #   config.secrets_path = /my/updated/path.yml
  # end
  
  def self.initializer=(val)
    options[:initializer] = val
  end
  
  def self.secrets_path=(pa)
    options[:secrets_path] = pa
    @@secrets = load_config(pa)
  end
  
  def self.tables_path=(pa)
    options[:tables_path] = pa
    @@tables = load_config(pa)
  end
  
  def self.queue=(val)
    options[:queue] = val
  end
  
  def self.processed_path=(pa)
    options[:processed_path] = pa
  end
  
  def self.failed_path=(pa)
    options[:failed_path] = pa
  end
  
  def self.poll_interval=(val)
    options[:poll_interval] = val
  end
  
  def self.file_ext=(val)
    options[:file_ext] = val if [:csv, :txt].include? val
  end
  
end

require 'broker/application'
