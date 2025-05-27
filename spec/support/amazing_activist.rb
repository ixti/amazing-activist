# frozen_string_literal: true

I18n.load_path << File.expand_path("#{__dir__}/locale/en.yml")

module Unconventional
  class ClassNaming < AmazingActivist::Base; end
end

class BrokenContractActivity < AmazingActivist::Base
  class WithHandler < self
    on_broken_outcome { |value| success(value) }
  end

  class WithHandlerOverride < WithHandler
    on_broken_outcome do |value|
      failure(:broken_contract, context: { value: value })
    end
  end

  def call = 42
end

class UnhandledExceptionActivity < AmazingActivist::Base
  class WithHandler < self
    rescue_from("StandardError") do |exception|
      failure(:unhandled_exception, exception: exception)
    end
  end

  class WithHandlerOverride < WithHandler
    rescue_from("RuntimeError") do
      success(42)
    end
  end

  prop :error_class, _Class(Exception), default: -> { RuntimeError }

  def call
    raise error_class, "Boom!"
  end
end

module Pretty
  class DamnGoodActivity < AmazingActivist::Base
    prop :params, _Hash(Symbol, _Any?), :**

    def call
      if :go_to_the_punk_rock_show == params[:what_do_you_want_to_do_today?]
        success("YEAH! Let's go to the punk rock show!")
      else
        failure(:bad_choice)
      end
    end
  end

  class IrresistibleActivity < AmazingActivist::Base
    prop :proposal, _Any?

    def call
      propose.unwrap!
      success
    end

    private

    def propose
      case proposal
      when :watch_tv_and_have_a_couple_of_brews
        failure(:you_can_do_better)
      else
        raise "Oopsie!"
      end
    end
  end

  class ParameterizedActivity < AmazingActivist::Base
    prop :code, Symbol
    prop :name, _String?

    def call
      success({ code:, name: })
    end
  end

  class InheritedParameterizedActivity < ParameterizedActivity
    prop :code,    Integer
    prop :details, String

    def call
      success({ code:, name:, details: })
    end
  end
end

class YetAnotherActivity < Pretty::DamnGoodActivity; end
