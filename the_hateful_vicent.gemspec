lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "the_hateful_vicent/version"

Gem::Specification.new do |spec|
  spec.name          = "the_hateful_vicent"
  spec.version       = TheHatefulVicent::Version::STRING
  spec.authors       = ["Lucas Fernandes"]
  spec.email         = ["lsfernandes92@gmail.com"]

  spec.summary       = "A gem for the best DSL to iOS apps with calabash"
  spec.description   = "A gem for the best DSL to iOS apps with calabash"
  spec.homepage      = "https://github.com/lsfernandes92/the_hateful_vicent"
  spec.license       = "MIT"

  spec.files         = Dir.glob('lib/**/*') #`git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'calabash-cucumber', '~> 0.20.5'
  spec.add_development_dependency "rspec"
end
