# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "rake"

group :test do
  gem "rspec"

  gem "simplecov"
  gem "simplecov-cobertura"

  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  gem "debug"

  gem "guard"
  gem "guard-rspec"
end

group :doc, optional: true do
  gem "asciidoctor"
  gem "yard"
end
