# frozen_string_literal: true

require "dry-validation"

require_relative "./broken_contract_error"

module AmazingActivist
  module Contractable
    DEFAULT_BROKEN_OUTCOME_HANDLER = lambda do |outcome|
      raise BrokenContractError, "#{self.class}#call returned #{outcome.class} instead of Outcome"
    end
    private_constant :DEFAULT_BROKEN_OUTCOME_HANDLER

    protected

    # @api internal
    def broken_contract_handler
      return @broken_contract_handler if defined?(@broken_contract_handler)

      ancestors.each do |klass|
        next unless klass < Base && klass != self

        return @broken_contract_handler = klass.broken_contract_handler
      end

      @broken_contract_handler = DEFAULT_BROKEN_OUTCOME_HANDLER
    end

    private

    def on_broken_outcome(&block)
      raise ArgumentError, "Handler block required." unless block

      @broken_contract_handler = block
    end

    def contract(&block)
      const_set(:Contract, Class.new(Dry::Validation::Contract, &block))
    end
  end
end
