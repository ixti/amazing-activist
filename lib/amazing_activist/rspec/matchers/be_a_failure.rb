# frozen_string_literal: true

module AmazingActivist
  module RSpec
    module Matchers
      class BeAFailure
        include ::RSpec::Matchers::Composable

        def initialize(code = UNDEFINED)
          @actual = nil
          @code   = code
        end

        def with_code(code)
          @code = code
          self
        end

        def matches?(actual)
          @actual = actual

          return false unless actual.is_a?(AmazingActivist::Outcome::Failure)
          return false unless any_code? || values_match?(@code, actual.code)

          true
        end

        def description
          "be an AmazingActivist::Outcome::Failure"
        end

        def failure_message
          message = "expected #{actual_formatted}\nto #{description}"
          message << "\nwith code: #{::RSpec::Support::ObjectFormatter.format(@code)}" unless any_code?

          message
        end

        private

        def any_code?
          @code == UNDEFINED
        end

        def actual_formatted
          ::RSpec::Support::ObjectFormatter.format(@actual)
        end
      end
    end
  end
end
