# frozen_string_literal: true

require_relative "./matchers/be_a_failure"
require_relative "./matchers/be_a_success"

module AmazingActivist
  module RSpec
    module Matchers
      UNDEFINED = Object.new.freeze

      # @example With any code and any originator
      #   expect(outcome).to be_a_failure
      #
      # @example With specific code
      #   expect(outcome).to be_a_failure(:bad)
      def be_a_failure(...)
        BeAFailure.new(...)
      end

      # @example With any value
      #   expect(outcome).to be_a_success
      #
      # @example With value
      #   expect(outcome).to be_a_success(42)
      def be_a_success(...)
        BeASuccess.new(...)
      end
    end
  end
end
