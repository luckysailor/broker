# Use this hook to configure Broker

Broker.setup do |config|

  # Store private quickbase credentials for authenticating via the api
  config.secrets_path = 'config/secrets.yml'

  # Store a table mapping for all quickbase apps you want to connect with
  config.tables_path = 'config/quickbase_tables.yml'
  
  # Directory where your import files will be queued for import
  config.queue = 'broker_queue'
  
  # Directory where your successful imported files will be moved
  config.processed_path = 'broker_processed'
  
  # Directory where your failed imported files will be moved
  config.failed_path = 'broker_failed'
  
  # Uncomment to change the default file type to use for importing
  # [:csv, :txt]
  #config.file_ext = :csv
  
  # Sets polling wait time before checking for new import files
  config.poll_interval = 10

end
