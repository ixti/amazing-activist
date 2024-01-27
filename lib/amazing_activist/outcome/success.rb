# frozen_string_literal: true

module AmazingActivist
  module Outcome
    class Success
      # @return [AmazingActivist::Activity]
      attr_reader :activity

      # @param value [Object]
      # @param activity [AmazingActivist::Activity]
      def initialize(value, activity:)
        @value    = value
        @activity = activity
      end

      # @return [true]
      def success?
        true
      end

      # @return [false]
      def failure?
        false
      end

      # @api internal
      # @return [Array<(:success, Object, AmazingActivist::Activity)>]
      def deconstruct
        [:success, @value, @activity]
      end

      # @api internal
      # @return [Hash{success: Object, activity: AmazingActivist::Activity}]
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
