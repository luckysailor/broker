# Broker

Automate importing of data to Quickbase applications using a file queue

## Installation

Add this line to your application's Gemfile:

```ruby
    gem broker
```

And then execute:

```ruby
    $ bundle
```

Or install it yourself as:

```ruby
    $ gem install broker
```

## Initial Setup

Setup the initializers, config files, and structure by:

```ruby
$ broker install
```

The following files will be generated for you:

```ruby
/config/secrets.yml
/config/quickbase_tables.yml
/config/initializers/broker.rb
```

Enter your Quickbase connection credentials in `/config/secrets.yml` file.

```ruby
 # Place your quickbase credentials here
 # Do not check into version control, keep your secrets safe
 #
 # ORG -> if you are using a custom subdomain such as mycompany.quickbase.com,
 # you will set ORG:  mycompany, otherwise www is the default
 #
 #
 ORG:  www
 USERNAME:  billy_the_kid@user.com
 PASSWORD:  mickeymouse
```

## Generate the Queue

Once running, Broker will poll for new files in a directory structure that resembles your Quickbase apps and tables. Before starting Broker up, you need to generate the Queue.

1. Edit the initializer file in `/config/initializers/broker.rb` to customize the location you want the Queue to be generated, along with changing the default locations for your secrets.yml and quickbase_tables.yml to be.

2. Open up your `quickbase_tables.yml` configuration file and enter your quickbase app/table structure. This convention must be strictly followed as it is the way Broker is able to connect with Quickbase. Create as many app config blocks as you need.

```ruby
tracker:									# Give each of your apps a simple unique key name
  name: Job Tracker							# This is the official Quickbase App Name
  token:  your_apps_token_for_tracker		# Quickbase API token you assigned to the app
  tables:									# Generic tables key that points to your tables
    main:  table_dbid						# Give each of your tables a simple unique key name, pointing to the Quickbase table dbid
    people:  table_dbid
```

3. Once your `quickbase_table.yml` configuration is done, you are ready to generate the Broker Queue.

```ruby
$ broker queue -c

$ broker queue -u
```

Your Queue has been created using your `quickbase_tables.yml` settings.

```ruby
broker_queue/tracker/main
broker_queue/tracker/people

broker_processed
```

## Boot Broker

```ruby
$ broker start -s
```

Broker will be running and watching for new files inside your Queue. New files will be swept up, imported to Quickbase, and then moved out to the Processed folder.


## In the Works

1. Broker activity - successful/failed import records save to a MongoDB

2. Web UI to monitor Broker activity

3. Mount Broker to a Rails App

4. 


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
