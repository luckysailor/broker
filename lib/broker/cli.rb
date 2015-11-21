require 'thor'

module Broker
  class CLI < Thor
    include Thor::Actions
    
    def self.source_root
      File.dirname(__FILE__) + "/templates"
    end
    
    desc "install", "install and configure broker"
    def install
      require 'broker'
      unless already_installed?
        inject_initializer
        inject_secrets
        inject_tables
        welcome
      else
        say "Broker is already Installed/Setup!"
      end
    end
    
    desc "queue", "make and update your queue"
    method_option :create,
                  type: :boolean,
                  default: false,
                  aliases: "-c",
                  banner: "Generate your queue folder structure"
    method_option :delete,
                  type: :boolean,
                  default: false,
                  aliases: "-d",
                  banner: "Delete your queue folder structure"
    method_option :update,
                  type: :boolean,
                  default: false,
                  aliases: "-u",
                  banner: "Generate your queue folder structure"
    def queue
      require 'broker'
      empty_dir = !Dir.exists?(Broker.options[:queue])
      
      if options[:create] && empty_dir
        FileUtils.mkdir Broker.options[:queue]
        FileUtils.mkdir Broker.options[:processed_path]
        say "Your Q has been created at:"
        puts "#{Broker.options[:queue]}"
      end
      
      if options[:update] && !empty_dir
        base_path = "#{Broker.options[:queue]}"
        roots     = Broker.table_keys
        tables    = []
        
        make_tree(base_path, roots)
         
        Broker.tables.each do |key, val|
          tables = val['tables'].keys
          make_tree("#{base_path}/#{key}", tables)
        end
      end
    end
    
    desc "inject_initializer", "add initializer"
    def inject_initializer
      puts 'add initializer for broker configuration'
      copy_file "broker.rb", "config/initializers/broker.rb"
    end
    
    desc "inject_secrets", "add secrets"
    def inject_secrets
      puts 'add secrets yaml for broker authentication environment variables'
      copy_file "secrets.yml", "config/secrets.yml"
    end
    
    desc "inject_tables", "add table mapping"
    def inject_tables
      puts 'add broker_tables for setting up table mappings'
      copy_file "quickbase_tables.yml", "config/quickbase_tables.yml"
    end
    
    desc "start", "boot up broker service"
    method_option :standalone,
                  type: :boolean,
                  default: false,
                  aliases: "-s",
                  banner: "Boots w/out web service"
    method_option :web,
                  type: :boolean,
                  default: false,
                  aliases: "-w",
                  banner: "Boots w/ web service"
    def start
      
      require 'broker'
      
      if options[:standalone]
        
        io_read, io_write = IO.pipe
        
        %w(INT TERM USR1 USR2 TTIN).each do |sig|
          begin
            Signal.trap(sig) do
              io_write.puts(sig)
            end
          rescue ArgumentError
            puts "Signal #{sig} not valid"
          end
        end
        
        require 'broker/launcher'
        @launcher = Broker::Launcher.new
        
        begin
          puts "launched with PID #{Process.pid}"
          @launcher.run
          
          while readable_io = IO.select([io_read])
            signal = readable_io.first[0].gets.strip
            catch_signal(signal)
          end
        rescue Interrupt
          puts "Shutting down"
          @launcher.stop
          exit(0)
        end
        
      elsif options[:web]
        puts "web service not implemented yet"
      end
    end            
    
    desc "welcome", "invite to broker"
    def welcome
      say ""
      say ""
      say ""
      say "*************************************************"
      say "*************************************************"
      say "Broker Successfully Installed!"
      say "*************************************************"
      say ""
      say "Default Config files created for you"
      say ""
      say "You can change the config paths in:"
      say "config/initializers/broker.rb"
      say ""
      say "1. Enter your Quickbase credentials in:"
      say "/config/secrets.yml"
      say ""
      say "2. Set up your Table Mappings in:"
      say "/config/quickbase_tables.yml"
      say ""
      say "*************************************************"
      say ""
      say "Update your Broker Q by running:"
      say ""
      say "$ broker update_q"
      say ""
    end
    
    private
    
    def catch_signal(sig)
      case sig
      when 'INT'
        raise Interrupt
      when 'TERM'
        raise Interrupt
      when 'USR1'
      when 'USR2'
      when 'TTIN'
      end
    end
    
    def make_tree(base_path, folders=[])
      folders.each do |f|
        unless valid_path?("#{base_path}/#{f}")
          Dir.mkdir("#{base_path}/#{f}")
          say "created: #{base_path}/#{f}"
        end
      end
    end
    
    def valid_path?(path)
      Dir.exists?(path)
    end
    
    def already_installed?
      files = Broker.config_files
      files.each do |f| 
        return false unless File.exists?(f)
      end && true
    end
    
    
  end
end
