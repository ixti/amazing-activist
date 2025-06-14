# frozen_string_literal: true

RSpec.describe AmazingActivist::Success do
  subject(:outcome) { described_class.new(success, activity: activity) }

  let(:success)  { :dobby_is_free }
  let(:activity) { Pretty::DamnGoodActivity.allocate }

  it { is_expected.to be_an AmazingActivist::Outcome }

  describe "#inspect" do
    subject { outcome.inspect }

    it { is_expected.to eq "#<AmazingActivist::Success (Pretty::DamnGoodActivity)>" }
  end

  describe "#to_s" do
    it "is an alias of #inspect" do
      expect(outcome.method(:to_s)).to eq(outcome.method(:inspect))
    end
  end

  describe "#deconstruct" do
    subject { outcome.deconstruct }

    it { is_expected.to eq([:success, success, activity]) }
  end

  describe "#deconstruct_keys" do
    subject { outcome.deconstruct_keys(nil) }

    it { is_expected.to eq({ success:, activity: }) }
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

    it { is_expected.to be success }
  end

  describe "#value_or" do
    it "requires either default value or a block" do
      expect { outcome.value_or }.to raise_error(ArgumentError)
    end

    context "when default value given" do
      it "returns actual value" do
        expect(outcome.value_or(:literal)).to be success
      end
    end

    context "when block given" do
      it "returns actual value" do
        expect(outcome.value_or { :result_of_block }).to be success
      end

      it "does not actually call it" do
        expect { |b| outcome.value_or(&b) }.not_to yield_control
      end
    end

    context "when both block, and literal given" do
      it "returns actual value" do
        expect(outcome.value_or { :result_of_block }).to be success
      end

      it "does not actually call it" do
        expect { |b| outcome.value_or(&b) }.not_to yield_control
      end

      it "warns that block supersedes argument" do
        expect { outcome.value_or(:literal) { :result_of_block } }
          .to output(%r{block supersedes}).to_stderr
      end
    end
  end
end
