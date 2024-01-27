# frozen_string_literal: true

RSpec.describe AmazingActivist::Outcome::Success do
  subject(:outcome) { described_class.new(value, activity: activity) }

  let(:value)    { :dobby_is_free }
  let(:activity) { AmazingActivist::Activity.new }

  describe "#deconstruct" do
    subject { outcome.deconstruct }

    it { is_expected.to eq([:success, value, activity]) }
  end

  describe "#deconstruct_keys" do
    subject { outcome.deconstruct_keys(nil) }

    it { is_expected.to eq({ success: value, activity: activity }) }
  end

  describe "#success?" do
    subject { outcome.success? }

    it { is_expected.to be true }
  end

  describe "#failure?" do
    subject { outcome.failure? }

    it { is_expected.to be false }
  end

  describe "#unwrap!" do
    subject { outcome.unwrap! }

    it { is_expected.to be value }
  end

  describe "#value_or" do
    it "returns wrapped value" do
      expect(outcome.value_or { Object.new }).to be value
    end

    it "ignores given block" do
      expect { |b| outcome.value_or(&b) }.not_to yield_control
    end
  end
end
