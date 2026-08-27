# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubygems/package"

require_relative "lib/hablaba/version"

Rake::TestTask.new(:test) do |t|
  t.libs << "lib" << "test"
  t.test_files = FileList["test/**/test_*.rb"]
  t.warning = true
end

# rubygems.org applies these rules when a gem is pushed, and rejects the push
# if they are broken. RubyGems before 4.0 builds a gem with a blank
# original_platform, which trips all three, so check here rather than finding
# out from a failed `gem push`.
PLATFORM_FORMAT = /\A[a-zA-Z0-9._-]+\z/.freeze

desc "Check the built gem against the rules rubygems.org enforces on push"
task :validate_gem do
  path = "pkg/hablaba-#{Hablaba::VERSION}.gem"
  raise "#{path} not built; run `rake build` first" unless File.exist?(path)

  spec = Gem::Package.new(path).spec
  platform = spec.original_platform.to_s
  errors = []

  errors << "platform is blank" if platform.empty?
  unless platform.empty? || platform.match?(PLATFORM_FORMAT)
    errors << "platform #{platform.inspect} may only contain letters, numbers, periods, dashes and underscores"
  end
  if spec.full_name.end_with?(".", "-", "_")
    errors << "full name #{spec.full_name.inspect} may not end with a period, dash or underscore"
  end

  unless errors.empty?
    abort <<~MESSAGE
      #{path} would be rejected by rubygems.org:
        - #{errors.join("\n  - ")}

      Built with RubyGems #{Gem::VERSION}. RubyGems before 4.0 writes a blank
      original_platform; `gem update --system` fixes it at the source.
    MESSAGE
  end

  puts "#{path} looks publishable (platform: #{platform}, built with RubyGems #{Gem::VERSION})"
end

# Bundler's `release` task depends on `build`, so this guards `rake release` too.
Rake::Task["build"].enhance { Rake::Task["validate_gem"].invoke }

desc "Run tests"
task default: :test
