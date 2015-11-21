# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'broker/version'

Gem::Specification.new do |gem|
  gem.name          = "broker"
  gem.version       = Broker::VERSION
  gem.authors       = ["Shawn Henley"]
  gem.email         = ["shawn@luckysailor.net"]
  gem.description   = gem.summary = "Simple utility to automate the importing of data through the Quickbase API by polling a folder queue for new files, and pushing the data to your Quickbase apps."
  gem.homepage      = "https://github.com/luckysailor/broker"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = ["broker"]#gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'sinatra'
end
