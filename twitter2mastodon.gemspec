lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "twitter2mastodon/version"

Gem::Specification.new do |spec|
  spec.name = "twitter2mastodon"
  spec.version = Twitter2mastodon::VERSION
  spec.authors = ["Armand Fardeau"]
  spec.email = ["fardeauarmand@gmail.com"]

  spec.summary = "Tweet from Twitter to Mastodon."
  spec.description = "Import Tweet from twitter and publish them to Mastodon."
  spec.homepage = "https://github.com/armandfardeau/twitter2mastodon"
  spec.license = "MIT"

  raise "RubyGems 2.0 or newer is required to protect against public gem pushes." unless spec.respond_to?(:metadata)

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/armandfardeau/twitter2mastodon"
  spec.metadata["changelog_uri"] = "https://github.com/armandfardeau/twitter2mastodon/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.65.0"
  spec.add_development_dependency "simplecov", "~> 0.16.1"
end
