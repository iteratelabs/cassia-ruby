
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cassia/ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "cassia-ruby"
  spec.version       = Cassia::Ruby::VERSION
  spec.authors       = ["Adeline Wang", "James Russo"]
  spec.email         = ["adelinewang679@gmail.com", "jdrusso1020@gmail.com"]

  spec.summary       = "a ruby api client for the cassia router api"
  spec.description   = "a ruby api client for the cassia router api"
  spec.homepage      = "https://github.com/iteratelabs/cassia-ruby.git"
  spec.license       = "MIT"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "virtus"
  spec.add_dependency "ld-eventsource"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "vcr"
end
