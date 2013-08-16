# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'broadbean/version'

Gem::Specification.new do |gem|
  gem.name          = "broadbean"
  gem.version       = Broadbean::VERSION
  gem.authors       = ["Robert Vracaric"]
  gem.email         = ["rvracaric@selfmgmt.com"]
  gem.description   = %q{Sends commands to AdCourier and parses responses.}
  gem.summary       = %q{Communication with Broadbean's AdCourier service.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'

  gem.add_dependency 'nokogiri'
  gem.add_dependency 'activesupport', '>= 3.0.0'
end
