# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_ember_validations/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_ember_validations"
  spec.version       = RailsEmberValidations::VERSION
  spec.authors       = ["Alexandros M"]
  spec.email         = ["alexandros.mastas@gmail.com"]
  spec.description   = "Server side validations for ember.js framework, model agnostic"
  spec.summary       = "Server side validations"
  spec.homepage      = ""
  spec.license       = "MIT"
   
  spec.files         = `git ls-files`.split($/) +  Dir["{app,config,lib}/**/*"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
