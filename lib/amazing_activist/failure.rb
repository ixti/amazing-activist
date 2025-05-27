# frozen_string_literal: true

module AmazingActivist
  class Failure < Literal::Data
    include Outcome

    # @!attribute [r] failure
    #   @return failure [Symbol]
    prop :failure, _Interface(:to_sym), :positional, &:to_sym

    # @!attribute [r] activity
    #   @return [AmazingActivist::Base]
    prop :activity, AmazingActivist::Base

    # @!attribute [r] exception
    #   @return [Exception, nil]
    prop :exception, _Nilable(Exception)

    # @!attribute [r] context
    #   @return [Hash]
    prop :context, _Hash(_Void, _Void), &:to_h

    prop :message, _String?, reader: false

    def code     = failure
    def success? = false
    def failure? = true

    # @api internal
    # @return [Array]
    def deconstruct
      [:failure, failure, activity]
    end

    # @api internal
    # @return [Hash]
    def deconstruct_keys(keys)
      if keys.nil? || keys.include?(:message)
        { failure:, activity:, exception:, context:, message: }
      else
        { failure:, activity:, exception:, context: }
      end
    end

    # Failure message.
    #
    # @return [String]
    def message
      @message || Polyglot.new(activity).message(failure, **context)
    end
  end
end
