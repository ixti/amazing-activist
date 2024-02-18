# frozen_string_literal: true

require_relative "../polyglot"
require_relative "../unwrap_error"

module AmazingActivist
  module Outcome
    class Failure
      # @return [Symbol]
      attr_reader :code

      # @return [AmazingActivist::Base]
      attr_reader :activity

      # @return [Exception, nil]
      attr_reader :exception

      # @return [Hash]
      attr_reader :context

      # @param code [#to_sym]
      # @param activity [AmazingActivist::Activity]
      # @param message [#to_s, nil]
      # @param exception [Exception, nil]
      # @param context [Hash]
      def initialize(code, activity:, message:, exception:, context:)
        @code      = code.to_sym
        @activity  = activity
        @message   = message&.to_s
        @exception = exception
        @context   = context
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
      # @return [Array]
      def deconstruct
        [:failure, @code, @activity]
      end

      # @api internal
      # @return [Hash]
      def deconstruct_keys(_)
        { failure: @code, activity: @activity, message: message, exception: exception, context: context }
      end

      # @yieldparam self [self]
      def value_or
        yield self
      end

      # @raise [UnwrapError]
      def unwrap!
        raise UnwrapError, self
      end

      # Failure message.
      #
      # @return [String]
      def message
        @message || Polyglot.new(@activity).message(@code, **context)
      end
    end
  end
end
