# frozen_string_literal: true

module AmazingActivist
  class Success < Literal::Data
    include Outcome

    # @!attribute [r] success
    #   @return [AmazingActivist::Base]
    prop :value, _Any?, :positional

    # @!attribute [r] activity
    #   @return [AmazingActivist::Base]
    prop :activity, AmazingActivist::Base

    def failure? = false
    def success? = true

    # @api internal
    # @return [Array]
    def deconstruct
      [:success, value, activity]
    end

    # @api internal
    # @return [Hash]
    def deconstruct_keys(_)
      { success: value, activity: }
    end
  end
end
