# frozen_string_literal: true

require_relative "./error"

module AmazingActivist
  class UnwrapError < Error
    # @return [Outcome::Failure]
    attr_reader :failure

    # @param failure [Outcome::Failure]
    def initialize(failure)
      @failure = failure

      super(failure.message)
    end
  end
end
