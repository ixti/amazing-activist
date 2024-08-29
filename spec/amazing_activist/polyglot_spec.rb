# frozen_string_literal: true

RSpec.describe AmazingActivist::Polyglot do
  subject(:polyglot) { described_class.new(activity) }

  describe "#message" do
    subject { polyglot.message(code, **failure_context) }

    let(:locale)          { :en }
    let(:code)            { :blablabla }
    let(:failure_context) { {} }
    let(:activity)        { Pretty::DamnGoodActivity.new }

    around { |ex| I18n.with_locale(locale, &ex) }

    it { is_expected.to eq "<pretty/damn_good_activity> failed - blablabla" }

    context "when activity class name has no Activity suffix" do
      let(:activity) { Unconventional::ClassNaming.new }

      it { is_expected.to eq "<unconventional/class_naming> failed - blablabla" }
    end

    context "when activity class is anonymous" do
      let(:activity) { Class.new(AmazingActivist::Base).new }

      it { is_expected.to eq "<(anonymous activity)> failed - blablabla" }
    end

    context "when there's generic failure message for selected locale" do
      let(:locale) { :gl }
      let(:code)   { :not_implemented }

      it { is_expected.to eq "<pretty/damn_good_activity> non ten implementación" }
    end

    context "when there's named failure message for given code" do
      let(:code) { :bad_choice }

      it { is_expected.to eq "Choose something else!" }
    end

    context "when translation key has no `amazing_activist.` scope" do
      let(:activity) { YetAnotherActivity.new }
      let(:code)     { :bad_choice }

      it { is_expected.to eq "I repeat! Choose something else!" }
    end

    context "when there's generic code message with `amazing_activist.` scope" do
      let(:code)            { :you_shall_not_pass }
      let(:failure_context) { { name: "Barlog" } }

      it { is_expected.to eq "Barlog, get lost already!" }
    end

    context "when there's generic code message without `amazing_activist.` scope" do
      let(:code)            { :famous_last_words }
      let(:failure_context) { { name: "LEEROY" } }

      it { is_expected.to eq "LEEROY JENKINS!!!" }
    end
  end
end
