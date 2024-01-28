# frozen_string_literal: true

RSpec.describe AmazingActivist::Outcome::Failure do
  subject(:outcome) { described_class.new(code, activity: activity, context: { foo: :bar }) }

  let(:code)     { :you_shall_not_pass }
  let(:activity) { AmazingActivist::Activity.new }

  describe "#deconstruct" do
    subject { outcome.deconstruct }

    it { is_expected.to eq([:failure, code, activity, { foo: :bar }]) }
  end

  describe "#deconstruct_keys" do
    subject { outcome.deconstruct_keys(nil) }

    it { is_expected.to eq({ failure: code, activity: activity, context: { foo: :bar } }) }
  end

  describe "#success?" do
    subject { outcome.success? }

    it { is_expected.to be false }
  end

  describe "#failure?" do
    subject { outcome.failure? }

    it { is_expected.to be true }
  end

  describe "#unwrap!" do
    it "raises #{AmazingActivist::UnwrapError}" do
      expect { outcome.unwrap! }.to raise_error(
        an_instance_of(AmazingActivist::UnwrapError).and(
          having_attributes(
            failure: outcome,
            message: "#{activity.class} failed with #{code}"
          )
        )
      )
    end
  end

  describe "#value_or" do
    it "returns result of the given block" do
      expect(outcome.value_or { :result_of_block }).to be :result_of_block
    end

    it "yields control to the given block with self as a sole argument" do
      expect { |b| outcome.value_or(&b) }.to yield_with_args(outcome)
    end
  end

  describe "#message" do
    subject { outcome.message }

    it { is_expected.to eq "#{activity.class} failed with #{code}" }

    context "when failure context has :message" do
      let(:outcome) { described_class.new(code, activity: activity, context: { message: message }) }
      let(:message) { "You shall not pass!" }

      it { is_expected.to eq message }
    end
  end
end
