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

  spec.metadata = {
    "source_code_uri" => spec.homepage,
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/master/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir["lib/**/*.rb"] + %w[README.md CHANGELOG.md LICENSE]
  spec.require_paths = ["lib"]
end
