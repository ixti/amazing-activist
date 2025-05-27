# frozen_string_literal: true

require "active_support/core_ext/object/blank"
require "active_support/core_ext/string/inflections"

module AmazingActivist
  # @api internal
  class Polyglot
    def initialize(activity)
      @activity = activity
    end

    # The i18n key for the message will be looked in namespaces:
    #
    # * `amazing_activist.activities.[activity].failures`
    # * `activities.[activity].failures`
    # * `amazing_activist.failures`
    # * `activities.failures`
    #
    # Thus, if activity `Pretty::DamnGoodActivity` failed with `:bad_choise`
    # code the lookup will be:
    #
    # * `amazing_activist.activities.pretty/damn_good_activity.failures.bad_choice
    # * `activities.pretty/damn_good_activity.failures.bad_choice
    # * `amazing_activist.failures.bad_choice
    # * `activities.failures.bad_choice
    #
    # If there's no translation with any of the above keys, a generic
    # non-translated message will be used:
    #
    #     <pretty/damn_good_activity> failed - bad_choice
    #
    # @return [String] Failure message
    def message(code, **context)
      activity = @activity.class.name&.underscore
      default  = [
        :"amazing_activist.failures.#{code}",
        :"activities.failures.#{code}",
        "<%{activity}> failed - %{code}" # rubocop:disable Style/FormatStringToken
      ]

      if activity
        i18n_key = :"amazing_activist.activities.#{activity}.failures.#{code}"
        default.unshift(:"activities.#{activity}.failures.#{code}")
      else
        activity = "(anonymous activity)"
        i18n_key = default.shift
      end

      I18n.t(i18n_key, **context, default: default, activity: activity, code: code)
    end
  end
end
