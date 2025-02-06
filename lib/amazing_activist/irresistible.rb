# frozen_string_literal: true

require_relative "./broken_contract_error"
require_relative "./contractable"
require_relative "./rescuable"
require_relative "./unwrap_error"

module AmazingActivist
  module Irresistible
    include Contractable
    include Rescuable

    # Initialize and call activity.
    #
    # @see #initialize
    # @see #call
    def call(*args, **kwargs, &block)
      activity = new(*args, **kwargs)
      outcome  = irresistible_call(activity, &block)

      unless outcome.is_a?(Outcome::Failure) || outcome.is_a?(Outcome::Success)
        return activity.instance_exec(outcome, &broken_contract_handler)
      end

      outcome
    end

    private

    # @api internal
    def irresistible_call(activity, &block)
      activity.call(&block)
    rescue UnwrapError => e
      e.failure
    rescue Exception => e # rubocop:disable Lint/RescueException
      handler = rescue_handler_for(e)
      raise unless handler

      activity.instance_exec(e, &handler)
    end
  end
end
