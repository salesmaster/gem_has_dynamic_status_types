# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_dynamic_status_types/version'

Gem::Specification.new do |spec|
  spec.name          = 'has_dynamic_status_types'
  spec.version       = HasDynamicStatusTypes::VERSION
  spec.authors       = ['Benjamin Martin']
  spec.email         = ['benjamin@salemaster.co.uk']
  spec.description   = %q{Add differenet statuses to your models}
  spec.summary       = %q{Models can has different statuses, but different flavours of the same model the same status might mean something else .. crazy!}
  spec.homepage      = 'http://www.salesmaster.co.uk'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'timecop'

  spec.add_dependency 'activerecord', '>=3.2.1', '<5.0'
end
