# frozen_string_literal: true

module AmazingActivist
  # Abstract activity class.
  #
  # == Example
  #
  # [source,ruby]
  # ----
  # class OnboardActivity < AmazingActivist::Base
  #   prop :params, _Hash(Symbol, _Any?), :**
  #
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

    class << self
      # Prohibit `Activity.new(...).call` style, as it makes activist not much `Irresistable`
      private :new
    end

    # @return [Success, Failure]
    def call
      failure(:not_implemented)
    end

    private

    # @param value (see Success#initialize)
    # @return [Success]
    def success(value = nil)
      Success.new(value, activity: self)
    end

    # @param code (see Failure#initialize)
    # @param context (see Failure#initialize)
    # @return [Failure]
    def failure(code, message: nil, exception: nil, context: {})
      Failure.new(code, activity: self, message: message, exception: exception, context: context)
    end
  end
end
