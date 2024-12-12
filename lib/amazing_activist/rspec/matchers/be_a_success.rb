# frozen_string_literal: true

module AmazingActivist
  module RSpec
    module Matchers
      class BeASuccess
        include ::RSpec::Matchers::Composable

        def initialize(value = UNDEFINED)
          @actual = nil
          @value  = value
        end

        def with_value(value)
          @value = value
          self
        end

        def matches?(actual)
          @actual = actual

          return false unless actual.is_a?(AmazingActivist::Outcome::Success)
          return false unless any_value? || values_match?(@value, actual.unwrap!)

          true
        end

        def description
          "be an AmazingActivist::Outcome::Success"
        end

        def failure_message
          message = "expected #{actual_formatted}\nto #{description}"
          message << "\nwith value: #{::RSpec::Support::ObjectFormatter.format(@value)}" unless any_value?

          message
        end

        private

        def any_value?
          @value == UNDEFINED
        end

        def actual_formatted
          ::RSpec::Support::ObjectFormatter.format(@actual)
        end
      end
    end
  end
end
