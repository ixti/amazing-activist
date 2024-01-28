# frozen_string_literal: true

RSpec.describe AmazingActivist::UnwrapError do
  subject(:error) { described_class.new(failure) }

  let(:failure)  { AmazingActivist::Outcome::Failure.new(:unknown, activity: activity, context: {}) }
  let(:activity) { AmazingActivist::Base.new }

  describe "#failure" do
    subject { error.failure }

    it { is_expected.to be failure }
  end

  describe "#message" do
    subject { error.message }

    it { is_expected.to eq failure.message }
  end
end
