# frozen_string_literal: true

require_relative "lib/hablaba/version"

Gem::Specification.new do |spec|
  spec.name     = "hablaba"
  spec.version  = Hablaba::VERSION
  spec.authors  = ["Adrian Duyzer"]
  spec.email    = ["adrianduyzer@gmail.com"]

  spec.summary  = "Spanish verb conjugator"
  spec.description = "Hablaba conjugates regular Spanish verbs across seven tenses. " \
                     "Pure Ruby, with no runtime dependencies."
  spec.homepage = "https://github.com/adriand/hablaba"
  spec.license  = "MIT"

  spec.required_ruby_version = ">= 3.1"

  # Set explicitly rather than left to default: RubyGems before 4.0 writes a
  # blank original_platform into the packaged metadata, which rubygems.org
  # rejects on push ("Platform can't be blank"). Assigning it keeps the gem
  # publishable no matter which RubyGems builds it. See rake validate_gem.
  spec.platform = Gem::Platform::RUBY

  spec.metadata = {
    "source_code_uri" => spec.homepage,
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/master/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir["lib/**/*.rb"] + %w[README.md CHANGELOG.md LICENSE]
  spec.require_paths = ["lib"]
end
