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

## Setup

Setup the initializers, config files, and structure by:

```ruby
$ broker install
```

The following files will be generated for you:

```ruby
/config/secrets.yml
/config/quickbase_tables
/config/initializers/broker.rb
````

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
