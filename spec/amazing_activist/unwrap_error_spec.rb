# frozen_string_literal: true

RSpec.describe AmazingActivist::UnwrapError do
  subject(:error) { described_class.new(failure) }

  let(:activity)  { Pretty::DamnGoodActivity.allocate }
  let(:exception) { nil }

  let(:failure) do
    AmazingActivist::Failure.new(
      :nope,
      activity:  activity,
      message:   nil,
      exception: exception,
      context:   {}
    )
  end

  describe "#failure" do
    subject { error.failure }

    it { is_expected.to be failure }
  end

  describe "#message" do
    subject { error.message }

    it { is_expected.to eq failure.message }
  end

  describe "#cause" do
    subject { error.cause }

    it { is_expected.to be nil }

    context "when there was original exception" do
      let(:error) do
        begin
          raise original_exception
        rescue StandardError
          raise described_class, failure
        end
      rescue described_class => e
        e
      end

      let(:original_exception) { StandardError.new("you shall not pass") }

      it { is_expected.to be original_exception }
    end

    context "when failure has associated exception" do
      let(:exception) { StandardError.new("go away") }

      it { is_expected.to be exception }
    end

    context "when failure has associated exception, and there was original cause" do
      let(:error) do
        begin
          raise original_exception
        rescue StandardError
          raise described_class, failure
        end
      rescue described_class => e
        e
      end

      let(:exception) { StandardError.new("go away") }

      it { is_expected.to be exception }
    end
  end
end
