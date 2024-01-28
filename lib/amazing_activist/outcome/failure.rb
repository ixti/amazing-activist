# frozen_string_literal: true

require_relative "../unwrap_error"

module AmazingActivist
  module Outcome
    class Failure
      # @return [Symbol]
      attr_reader :code

      # @return [AmazingActivist::Activity]
      attr_reader :activity

      # @return [Hash{Symbol => Object}]
      attr_reader :context

      # @param code [#to_sym]
      # @param activity [AmazingActivist::Activity]
      # @param context [Hash{Symbol => Object}]
      def initialize(code, activity:, context:)
        @code     = code.to_sym
        @activity = activity
        @context  = context
      end

      # @return [true]
      def success?
        false
      end

      # @return [false]
      def failure?
        true
      end

      # @api internal
      # @return [Array<(:failure, Symbol, AmazingActivist::Activity, Hash{Symbol => Object})>]
      def deconstruct
        [:failure, @code, @activity, @context]
      end

      # @api internal
      # @return [Hash{success: Object, activity: AmazingActivist::Activity}]
      def deconstruct_keys(_)
        { failure: @code, activity: @activity, context: @context }
      end

      # @yieldparam self [self]
      def value_or
        yield self
      end

      # @raise [UnwrapError]
      def unwrap!
        raise UnwrapError, self
      end

      def message
        @context.fetch(:message) { "#{@activity.class} failed with #{@code}" }
      end
    end
  end
end
