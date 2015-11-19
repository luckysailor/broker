require 'quickbase_sync/version'
require 'yaml'

module QuickbaseSync
  NAME = "Quickbase Sync"
  
  DEFAULTS = {
    secrets_path: 'config/secrets.yml',
    tables_path: 'config/quickbase_sync_tables.yml',
    initializer: 'config/initializers/quickbase_sync.rb',
    poll_interval: 300,
    queue: 'quickbase_sync_queue',
    file_ext: :csv
  }
  
  @@secrets_path    = @@secrets_path ||= DEFAULTS[:secrets_path]
  @@tables_path 		= @@tables_path  ||= DEFAULTS[:tables_path]
  @@initializer 		= @@initializer  ||= DEFAULTS[:initializer]
  @@poll_interval		= @poll_interval ||= DEFAULTS[:poll_interval]
  @@queue           = @@queue        ||= DEFAULTS[:queue]
  @@file_ext        = @@file_ext     ||= DEFAULTS[:file_ext]
  
  @@secrets   			= YAML.load_file(@@secrets_path) rescue {}
  @@tables    			= YAML.load_file(@@tables_path) rescue {}
  
  def self.lookup_tbid(opt={})
    tables[opt[:app]]['tables'][opt[:table]]
  end
  
  def self.path
    Dir.pwd
  end
  
  def self.setup
    yield self unless launched?
  end
  
  def self.launched?
    defined?(QuickbaseSync::CLI)
  end
  
  def self.config_files
    [secrets_path, tables_path, initializer]
  end
  
  # def self.options
#     @options ||= DEFAULTS.dup
#   end
#
#   def self.options=(opt)
#     @options = opt
#   end
  
  def self.poll_interval
    @@poll_interval
  end
  
  def self.poll_interval=(val)
    @@poll_interval = val
  end
  
  def self.queue
    @@queue
  end
  
  def self.queue=(val)
    @@queue = val
  end
  
  def file_ext
    @@file_ext
  end
  
  def file_ext=(val)
    @@file_ext = val if [:csv, :tab].include? val
  end
  
  def self.secrets
    @@secrets
  end
  
  def self.secrets_path
    @@secrets_path
  end
  
  def self.secrets_path=(val)
    @@secrets_path = val
    @@secrets   = YAML.load_file(@@secrets_path) rescue {}
  end
  
  def self.tables
    @@tables
  end
  
  def self.tables_path
    @@tables_path
  end
  
  def self.tables_path=(val)
    @@tables_path = val
    @@tables = YAML.load_file(@@tables_path) rescue {}
  end
  
  def self.initializer
    @@initializer
  end
  
  def self.initializer=(val)
    @@initializer = val
  end
    
end

require 'quickbase_sync/application'

