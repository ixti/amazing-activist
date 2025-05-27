# frozen_string_literal: true

module AmazingActivist
  class Success < Literal::Data
    include Outcome

    # @!attribute [r] success
    #   @return [AmazingActivist::Base]
    prop :success, _Any?, :positional

    # @!attribute [r] activity
    #   @return [AmazingActivist::Base]
    prop :activity, AmazingActivist::Base

    def value    = success
    def success? = true
    def failure? = false

    # @api internal
    # @return [Array]
    def deconstruct
      [:success, success, activity]
    end

    # @api internal
    # @return [Hash]
    def deconstruct_keys(_)
      { success:, activity: }
    end
  end
end
