# frozen_string_literal: true

module AmazingActivist
  module Outcome
    UNDEFINED = Object.new.freeze

    def inspect
      "#<#{self.class} (#{@activity.class})>"
    end

    alias to_s inspect
  end
end
