# frozen_string_literal: true

module AmazingActivist
  module Outcome
    class Success
      # @return [AmazingActivist::Base]
      attr_reader :activity

      # @param value [Object]
      # @param activity [AmazingActivist::Base]
      def initialize(value, activity:)
        @value    = value
        @activity = activity
      end

      def inspect
        "#<#{self.class} (#{@activity.class}) #{@value.inspect}>"
      end

      alias to_s inspect

      # @return [true]
      def success?
        true
      end

      # @return [false]
      def failure?
        false
      end

      # @api internal
      # @return [Array]
      def deconstruct
        [:success, @value, @activity]
      end

      # @api internal
      # @return [Hash]
      def deconstruct_keys(_)
        { success: @value, activity: @activity }
      end

      # @return [Object]
      def value_or
        @value
      end

      # @return [Object]
      def unwrap!
        @value
      end
    end
  end
end
