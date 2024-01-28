# frozen_string_literal: true

RSpec.describe AmazingActivist::Base do
  describe ".call" do
    it "is a syntax sugar for new(...).call" do
      activity = described_class.new

      allow(described_class).to receive(:new).and_return(activity)
      allow(activity).to receive(:call).and_call_original

      described_class.call(rancid: "New face of rock'n'roll")

      expect(described_class).to have_received(:new)
      expect(activity).to have_received(:call)
    end
  end
end
