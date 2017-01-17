# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'harmony/service/version'

Gem::Specification.new do |spec|
  spec.name          = "harmony-service"
  spec.version       = Harmony::Service::VERSION
  spec.authors       = ["Matt Brooke-Smith"]
  spec.email         = ["matt@futureworkshops.com"]
  spec.summary       = "Gem which helps you to build Harmony services"
  spec.homepage      = "https://github.com/HarmonyMobile/harmony-service"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = gem.files.grep(/^bin/).map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sneakers", '~> 2.4'
  spec.add_dependency 'bunny', '~> 2.7.0.pre'
  spec.add_dependency "oj", '~> 2.17.4'
  spec.add_dependency 'rollbar', '~> 2.12'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
