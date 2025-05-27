# frozen_string_literal: true

module AmazingActivist
  class UnwrapError < Error
    # @return [Failure]
    attr_reader :failure

    # @param failure [Failure]
    def initialize(failure)
      @failure = failure

      super(failure.message)
    end

    # @return [Exception, nil]
    def cause
      @failure.exception || super
    end
  end
end
