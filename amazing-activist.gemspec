# frozen_string_literal: true

require_relative "./lib/amazing_activist/version"

Gem::Specification.new do |spec|
  spec.name     = "amazing-activist"
  spec.version  = AmazingActivist::VERSION
  spec.authors  = ["Alexey Zapparov"]
  spec.email    = ["alexey@zapparov.com"]

  spec.summary     = "Your friendly neighborhood activist."
  spec.description = "Another take on Command Pattern."
  spec.homepage    = "https://github.com/ixti/amazing-activist"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"]          = spec.homepage
  spec.metadata["source_code_uri"]       = "#{spec.homepage}/tree/v#{spec.version}"
  spec.metadata["bug_tracker_uri"]       = "#{spec.homepage}/issues"
  spec.metadata["changelog_uri"]         = "#{spec.homepage}/blob/v#{spec.version}/CHANGES.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    docs = %w[CHANGES.md LICENSE.txt README.adoc].freeze

    `git ls-files -z`.split("\x0").select do |f|
      f.start_with?("lib/") || docs.include?(f)
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.0.0"

  spec.add_dependency "activesupport"
  spec.add_dependency "i18n"
end
