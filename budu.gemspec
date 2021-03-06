# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'budu/version'

Gem::Specification.new do |spec|
  spec.name          = "budu"
  spec.version       = Budu::VERSION
  spec.authors       = ["easchwar"]
  spec.email         = ["easchwarzenbach@gmail.com"]

  spec.summary       = %q{Learn some stuff}

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files = Dir.glob("{bin,lib}/**/*") + %w( README.md)
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "test-unit"
  spec.add_runtime_dependency "sqlite3"
  spec.add_runtime_dependency "multi_json"
  spec.add_runtime_dependency "rack", "~> 1.0"
  spec.add_runtime_dependency "erubis"
end
