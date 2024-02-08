# frozen_string_literal: true

RSpec.describe AmazingActivist::Outcome::Failure do
  subject(:outcome) { described_class.new(code, activity: activity, context: failure_context) }

  let(:code)            { :you_shall_not_pass }
  let(:activity)        { Pretty::DamnGoodActivity.new }
  let(:failure_context) { { name: "Barlog" } }

  describe "#deconstruct" do
    subject { outcome.deconstruct }

    it { is_expected.to eq([:failure, code, activity, failure_context]) }
  end

  describe "#deconstruct_keys" do
    subject { outcome.deconstruct_keys(nil) }

    it { is_expected.to eq({ failure: code, activity: activity, context: failure_context }) }
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
          having_attributes(failure: outcome)
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
    subject(:message) { outcome.message }

    it { is_expected.to eq "Barlog, get lost already!" }

    it "generates message with Polyglot" do
      polyglot = instance_double(AmazingActivist::Polyglot, message: "Nope!")
      allow(AmazingActivist::Polyglot).to receive(:new).and_return(polyglot)

      expect(message).to eq("Nope!")
      expect(polyglot).to have_received(:message).with(code, **failure_context)
      expect(AmazingActivist::Polyglot).to have_received(:new).with(activity)
    end

    context "when failure context has :message" do
      let(:outcome) { described_class.new(code, activity: activity, context: { message: message }) }
      let(:message) { "You shall not pass!" }

      it { is_expected.to eq message }
    end
  end
end
