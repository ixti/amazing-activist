# frozen_string_literal: true

module AmazingActivist
  module Irresistible
    include Contractable
    include Rescuable

    # Initialize and call activity.
    #
    # @see #call
    def call(...)
      activity = new(...)
      outcome  = irresistible_call(activity)

      return activity.instance_exec(outcome, &broken_contract_handler) unless outcome.is_a?(Outcome)

      outcome
    end

    private

    # @api internal
    def irresistible_call(activity)
      activity.call
    rescue UnwrapError => e
      e.failure
    rescue Exception => e # rubocop:disable Lint/RescueException
      handler = rescue_handler_for(e)
      raise unless handler

      activity.instance_exec(e, &handler)
    end
  end
end
