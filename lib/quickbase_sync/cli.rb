require 'thor'

module QuickbaseSync
  class CLI < Thor
    include Thor::Actions
    
    def self.source_root
      File.dirname(__FILE__) + "/templates"
    end
    
    desc "install", "install and configure quickbase_sync"
    def install
      require 'quickbase_sync'
      unless already_installed?
        inject_initializer
        inject_secrets
        inject_tables
        welcome
      else
        say "QuickbaseSync is already Installed/Setup!"
      end
    end
    
    desc "inject_initializer", "add initializer"
    def inject_initializer
      puts 'add initializer for quickbase_sync configuration'
      copy_file "quickbase_sync.rb", "config/initializers/quickbase_sync.rb"
    end
    
    desc "inject_secrets", "add secrets"
    def inject_secrets
      puts 'add secrets yaml for quickbase_sync authentication environment variables'
      copy_file "secrets.yml", "config/secrets.yml"
    end
    
    desc "inject_tables", "add table mapping"
    def inject_tables
      puts 'add quickbase_sync_tables for setting up table mappings'
      copy_file "quickbase_sync_tables.yml", "config/quickbase_sync_tables.yml"
    end
    
    desc "welcome", "invite to quickbase_sync"
    def welcome
      say ""
      say ""
      say ""
      say "*************************************************"
      say "*************************************************"
      say "QuickbaseSync Successfully Installed!"
      say "*************************************************"
      say ""
      say "Default Config files created for you"
      say ""
      say "You can change the config paths in:"
      say "config/initializers/quickbase_sync.rb"
      say ""
      say "1. Enter your Quickbase credentials in:"
      say "/config/secrets.yml"
      say ""
      say "2. Set up your Table Mappings in:"
      say "/config/quickbase_sync_tables.yml"
      say ""
      say "*************************************************"
      say ""
      say "Update your QuickbaseSync Q by running:"
      say ""
      say "$ quickbase_sync update_q"
      say ""
    end
    
    private
    
    def already_installed?
      files = QuickbaseSync.config_files
      files.each do |f| 
        return false unless File.exists?(f)
      end && true
    end
    
    
  end
end
