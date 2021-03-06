# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iodruby/version'

Gem::Specification.new do |spec|
  spec.name          = "iodruby"
  spec.version       = Iodruby::VERSION
  spec.authors       = ["Martin Zerbib"]
  spec.email         = ["martin.zerbib@hp.com"]
  spec.summary       = %q{Idol OnDemand Ruby Client}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "unirest"
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
