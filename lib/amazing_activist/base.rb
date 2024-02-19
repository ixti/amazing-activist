# frozen_string_literal: true

require_relative "./irresistible"
require_relative "./outcome"

module AmazingActivist
  # Abstract activity class.
  #
  # == Example
  #
  # [source,ruby]
  # ----
  # class OnboardActivity < AmazingActivist::Base
  #   def call
  #     user = User.new(params)
  #
  #     return success(user) if user.save
  #
  #     failure(:invalid_params, user: user)
  #   end
  # end
  #
  # case OnboardActivity.call(email: "user@example.com")
  # in success: user
  #   Current.user = user
  #   redirect_to dashboard_url
  # else
  #   render :new, status: :unprocessable_entity
  # end
  # ----
  class Base
    extend Irresistible

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
    def failure(code, message: nil, exception: nil, context: {})
      Outcome::Failure.new(code, activity: self, message: message, exception: exception, context: context)
    end
  end
end
