# frozen_string_literal: true

require "i18n"
require "literal"
require "zeitwerk"

require_relative "./amazing_activist/version"

I18n.load_path += Dir[File.expand_path("#{__dir__}/amazing_activist/locale/*.yml")]

module AmazingActivist
  Loader = Zeitwerk::Loader.for_gem

  Loader.ignore("#{__dir__}/amazing-activist.rb")
  Loader.setup
end
