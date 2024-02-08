# frozen_string_literal: true

require "amazing_activist"

I18n.load_path << File.expand_path("#{__dir__}/locale/en.yml")

module Unconventional
  class ClassNaming < AmazingActivist::Base; end
end

module Pretty
  class DamnGoodActivity < AmazingActivist::Base
    def call
      if :go_to_the_punk_rock_show == params[:what_do_you_want_to_do_today?]
        success("YEAH! Let's go to the punk rock show!")
      else
        failure(:bad_choice)
      end
    end
  end
end
