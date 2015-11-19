# Use this hook to configure QuickbaseSync

QuickbaseSync.setup do |config|

  # Store private quickbase credentials for authenticating via the api
  config.secrets_path = 'config/secrets.yml'

  # Store a table mapping for all quickbase apps you want to connect with
  config.tables_path = 'config/quickbase_sync_tables.yml'
  
  # Directory where your import files will be queued for import
  config.queue = 'quickbase_sync_queue'
  
  # Uncomment to change the default file type to use for importing
  # [:csv, :tab]
  #config.file_ext = :csv
  
  # Sets polling wait time before checking for new import files
  config.poll_interval = 10

end
