# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quickbase_sync/version'

Gem::Specification.new do |gem|
  gem.name          = "quickbase_sync"
  gem.version       = QuickbaseSync::VERSION
  gem.authors       = ["Shawn Henley"]
  gem.email         = ["shawn@luckysailor.net"]
  gem.description   = gem.summary = "Automate the importing and exporting of data with Quickbase applications, using post requests."
  gem.homepage      = "https://github.com/luckysailor/quickbase_sync"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'sinatra'
end
