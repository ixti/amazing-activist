# frozen_string_literal: true

require "i18n"

require_relative "./inflector"

I18n.load_path += Dir[File.expand_path("#{__dir__}/locale/*.yml")]

module AmazingActivist
  # @api internal
  class Polyglot
    ANONYMOUS_ACTIVITY_NAME = "anonymous"
    private_constant :ANONYMOUS_ACTIVITY_NAME

    def initialize(activity)
      @activity = activity
    end

    # The i18n key for the message will be looked in namespaces:
    #
    # * `amazing_activist.activities.[activity].failures`
    # * `amazing_activist.failures`
    #
    # Thus, if activity `Pretty::DamnGoodActivity` failed with `:bad_choise`
    # code the lookup will be:
    #
    # * `amazing_activist.activities.pretty/damn_good.failures.bad_choice
    # * `amazing_activist.failures.bad_choice
    #
    # If there's no translation with any of the above keys, a generic
    # non-translated message will be used:
    #
    #     <pretty/damn_good> activity failed - bad_choice
    #
    # @return [String] Failure message
    def message(code, **context)
      default = [
        :"amazing_activist.failures.#{code}",
        "<%{activity}> activity failed - %{code}" # rubocop:disable Style/FormatStringToken
      ]

      if @activity.class.name
        activity = INFLECTOR.underscore(@activity.class.name).delete_suffix("_activity")
        i18n_key = :"amazing_activist.activities.#{activity}.failures.#{code}"
      else
        activity = "(anonymous)"
        i18n_key = default.shift
      end

      I18n.t(i18n_key, **context, default: default, activity: activity, code: code)
    end
  end
end
