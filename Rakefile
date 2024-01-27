# frozen_string_literal: true

require "bundler/gem_tasks"

desc "Run tests"
task :test do
  sh "bundle exec rspec --force-colour"
end

desc "Lint codebase"
task :lint do
  sh "bundle exec rubocop --color"
end

task default: %i[test lint]
