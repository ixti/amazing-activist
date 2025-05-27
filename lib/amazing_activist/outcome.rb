# frozen_string_literal: true

module AmazingActivist
  module Outcome
    UNDEFINED = Object.new.freeze
    private_constant :UNDEFINED

    # @return [String]
    def inspect = "#<#{self.class} (#{activity.class})>"

    alias to_s inspect

    # @overload value_or(default)
    #   @param default [Object]
    #   @return [Object] `default` if outcome is {Failure}
    #   @return [Object] {#success} otherwise
    #
    # @overload value_or(&block)
    #   Yelds outcome, when outcome is {Failure}, or returns {#success} without
    #   yielding the control when {Success}.
    #   @yield [self]
    #   @yieldparam self [Failure]
    #   @yieldreturn [Object] result of the block
    #
    # @raise [ArgumentError] if neither default value, nor block given
    def value_or(default = UNDEFINED)
      if block_given?
        warn "block supersedes default value argument" unless default == UNDEFINED

        return success if success?

        yield self
      elsif default != UNDEFINED
        return success if success?

        default
      else
        raise ArgumentError, "either default value, or block must be given"
      end
    end

    # @return [Object] {#success} if outcome is {Success}
    # @raise [UnwrapError] otherwise
    def unwrap!
      return success if success?

      raise UnwrapError, self
    end
  end
end
