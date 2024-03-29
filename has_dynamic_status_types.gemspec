# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_dynamic_status_types/version'

Gem::Specification.new do |spec|
  spec.name          = 'has_dynamic_status_types'
  spec.version       = HasDynamicStatusTypes::VERSION
  spec.authors       = ['Benjamin Martin']
  spec.email         = ['benjamin@salemaster.co.uk']
  spec.description   = %q{Add different statuses to your models}
  spec.summary       = %q{Models can have different statuses, but different flavours of the same model the same status might mean something else .. crazy!}
  spec.homepage      = 'http://www.salesmaster.co.uk'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord'
end
