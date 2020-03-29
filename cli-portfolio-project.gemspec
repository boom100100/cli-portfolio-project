lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
#require "cli/portfolio/project/version"

Gem::Specification.new do |spec|
  spec.name          = "cli-portfolio-project"
  spec.version       = 1
  spec.authors       = ["boom100100"]
  spec.email         = ["bsd231@nyu.edu"]

  spec.summary       = "Learn to count cards and master blackjack."
  spec.homepage      = "https://github.com/boom100100/cli-portfolio-project"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = "https://github.com/boom100100/cli-portfolio-project"
  spec.metadata["source_code_uri"] = "https://github.com/boom100100/cli-portfolio-project"
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
