# frozen_string_literal: true

RSpec.describe AmazingActivist::Outcome::Failure do
  subject(:outcome) do
    described_class.new(
      code,
      activity:  activity,
      message:   message,
      exception: exception,
      context:   failure_context
    )
  end

  let(:code)            { :you_shall_not_pass }
  let(:activity)        { Pretty::DamnGoodActivity.new }
  let(:message)         { nil }
  let(:exception)       { StandardError.new("nope") }
  let(:failure_context) { { name: "Barlog" } }

  describe "#inspect" do
    subject { outcome.inspect }

    it { is_expected.to eq "#<AmazingActivist::Outcome::Failure (Pretty::DamnGoodActivity) :you_shall_not_pass>" }
  end

  describe "#to_s" do
    it "is an alias of #inspect" do
      expect(outcome.method(:to_s)).to eq(outcome.method(:inspect))
    end
  end

  describe "#deconstruct" do
    subject { outcome.deconstruct }

    it { is_expected.to eq([:failure, code, activity]) }
  end

  describe "#deconstruct_keys" do
    subject { outcome.deconstruct_keys(nil) }

    it { is_expected.to include({ failure: code }) }
    it { is_expected.to include({ message: "Barlog, get lost already!" }) }
    it { is_expected.to include({ exception: exception }) }
    it { is_expected.to include({ context: failure_context }) }
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
    it "requires either default value or a block" do
      expect { outcome.value_or }.to raise_error(ArgumentError)
    end

    context "when default value given" do
      it "returns provided value" do
        expect(outcome.value_or(:literal)).to be :literal
      end
    end

    context "when block given" do
      it "returns result of the given block" do
        expect(outcome.value_or { :result_of_block }).to be :result_of_block
      end

      it "yields control to the given block with self as a sole argument" do
        expect { |b| outcome.value_or(&b) }.to yield_with_args(outcome)
      end
    end

    context "when both block, and literal given" do
      it "returns result of the given block" do
        expect(outcome.value_or(:literal) { :result_of_block }).to be :result_of_block
      end

      it "yields control to the given block with self as a sole argument" do
        expect { |b| outcome.value_or(:literal, &b) }.to yield_with_args(outcome)
      end

      it "warns that block supersedes argument" do
        expect { outcome.value_or(:literal) { :result_of_block } }
          .to output(%r{block supersedes}).to_stderr
      end
    end
  end

  describe "#message" do
    subject { outcome.message }

    it { is_expected.to eq "Barlog, get lost already!" }

    it "generates message with Polyglot" do
      polyglot = instance_double(AmazingActivist::Polyglot, message: "Nope!")
      allow(AmazingActivist::Polyglot).to receive(:new).and_return(polyglot)

      expect(subject).to eq("Nope!")
      expect(polyglot).to have_received(:message).with(code, **failure_context)
      expect(AmazingActivist::Polyglot).to have_received(:new).with(activity)
    end

    context "with explicit :message" do
      let(:message) { "You shall not pass!" }

      it { is_expected.to be message }
    end
  end

  describe "#exception" do
    subject { outcome.exception }

    it { is_expected.to be exception }
  end
end
