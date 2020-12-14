# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'explain_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "explain_parser"
  spec.version       = ExplainParser::VERSION
  spec.authors       = ["ainame"]
  spec.email         = ["s.namai.09@gmail.com"]
  spec.summary       = %q{Parser for result of EXPLAIN of MySQL}
  spec.description   = %q{Parser for result of EXPLAIN of MySQL
see: https://github.com/ainame/explain_parser
}
  spec.homepage      = "https://github.com/ainame/explain_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
