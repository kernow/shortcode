lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "shortcode/version"

Gem::Specification.new do |spec|
  spec.name          = "shortcode"
  spec.version       = Shortcode::VERSION
  spec.authors       = ["Jamie Dyer"]
  spec.email         = ["jamie@kernowsoul.com"]
  spec.description   = "Gem for parsing wordpress style shortcodes"
  spec.summary       = "Gem for parsing wordpress style shortcodes in ruby projects"
  spec.homepage      = "https://github.com/kernow/shortcode"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "parslet", "1.8.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "coveralls", "~> 0.8.22"
  spec.add_development_dependency "haml", "~> 5.0"
  spec.add_development_dependency "rails", "5.2.3"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "rubocop", "~> 0.68"
  spec.add_development_dependency "rubocop-rspec", "~> 1.32"
  spec.add_development_dependency "slim", "~> 3.0"
end
