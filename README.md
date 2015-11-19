# QuickbaseSync

Automate importing and exporting of data from Quickbase applications using post requests.

## Installation

Add this line to your application's Gemfile:

```ruby
    gem quickbase_sync
```

And then execute:

```ruby
    $ bundle
```

Or install it yourself as:

```ruby
    $ gem install quickbase_sync
```

## Setup

Setup the initializers, config files, and structure by:

```ruby
$ quickbase_sync install
```

The following files will be generated for you:

```ruby
/config/secrets.yml
/config/quickbase_sync_tables
/config/initializers/quickbase_sync.rb
````

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
