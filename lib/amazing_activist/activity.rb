# frozen_string_literal: true

require_relative "./outcome"

module AmazingActivist
  # Abstract activity class.
  #
  # == Example
  #
  # [source,ruby]
  # ----
  # class OnboardActivity < AmazingActivist::Activity
  #   def call
  #     user = User.new(params)
  #
  #     return success(user) if user.save
  #
  #     failure(:invalid_params, user: user)
  #   end
  # end
  # ----
  class Activity
    class << self
      # Convenience method to initialize and immediatelly call the activity.
      # @see #initialize
      # @see #call
      def call(...)
        new(...).call
      end
    end

    # @param params [Hash{Symbol => Object}]
    def initialize(**params)
      @params = params
    end

    # @return [Outcome::Success, Outcome::Failure]
    def call
      failure(:not_implemented)
    end

    private

    # @return [Hash{Symbol => Object}]
    attr_reader :params

    # @param value (see Outcome::Success#initialize)
    # @return [Outcome::Success]
    def success(value = nil)
      Outcome::Success.new(value, activity: self)
    end

    # @param code (see Outcome::Failure#initialize)
    # @param context (see Outcome::Failure#initialize)
    # @return [Outcome::Failure]
    def failure(code, **context)
      Outcome::Failure.new(code, activity: self, context: context)
    end
  end
end
