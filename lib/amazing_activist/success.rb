# frozen_string_literal: true

module AmazingActivist
  class Success
    include Outcome

    # @return [AmazingActivist::Base]
    attr_reader :activity

    # @param value [Object]
    # @param activity [AmazingActivist::Base]
    def initialize(value, activity:)
      @value    = value
      @activity = activity
    end

    def success? = true
    def failure? = false

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

    # @note Method requires default value or block (even though neither will
    #   be used) to keep it consistent with {Failure#value_or}, and avoid
    #   unpleasant surprises when code is not testing all possible outcomes.
    #
    # @raise [ArgumentError] if neither default value, nor block given
    # @return [Object] unwrapped value
    def value_or(default = UNDEFINED)
      raise ArgumentError, "either default value, or block must be given" if default == UNDEFINED && !block_given?

      unless default == UNDEFINED
        return @value unless block_given?

        warn "block supersedes default value argument"
      end

      @value
    end

    # @return [Object]
    def unwrap!
      @value
    end
  end
end
