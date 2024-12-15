# frozen_string_literal: true

require_relative "../polyglot"
require_relative "../unwrap_error"
require_relative "../undefined"

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
      # @param context [#to_h]
      def initialize(code, activity:, message:, exception:, context:)
        @code      = code.to_sym
        @activity  = activity
        @message   = message&.to_s
        @exception = exception
        @context   = context.to_h
      end

      def inspect
        "#<#{self.class} (#{@activity.class}) #{@code.inspect}>"
      end

      alias to_s inspect

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
      def deconstruct_keys(keys)
        deconstructed = { failure: @code, activity: @activity, exception: exception, context: context }
        deconstructed[:message] = message if keys.nil? || keys.include?(:message)

        deconstructed
      end

      # @overload value_or(default)
      #   @param default [Object]
      #   @return [Object] default value
      # @overload value_or(&block)
      #   @yieldparam self [self]
      #   @yieldreturn [Object] result of the block
      # @raise [ArgumentError] if neither default value, nor block given
      def value_or(default = UNDEFINED)
        raise ArgumentError, "either default value, or block must be given" if default == UNDEFINED && !block_given?

        unless default == UNDEFINED
          return default unless block_given?

          warn "block supersedes default value argument"
        end

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
