# frozen_string_literal: true

RSpec.describe AmazingActivist::Base do
  it "provides .call(...) syntax sugar" do
    activity = described_class.new

    allow(described_class).to receive(:new).and_return(activity)
    allow(activity).to receive(:call).and_call_original

    described_class.call(rancid: "New face of rock'n'roll")

    expect(described_class).to have_received(:new)
    expect(activity).to have_received(:call)
  end

  it "provides private `#success` outcome helper" do
    outcome = Pretty::DamnGoodActivity.call(what_do_you_want_to_do_today?: :go_to_the_punk_rock_show)

    expect(outcome).to be_a(AmazingActivist::Outcome::Success)
    expect(outcome.unwrap!).to eq("YEAH! Let's go to the punk rock show!")
  end

  it "provides private `#failure` outcome helper" do
    outcome = Pretty::DamnGoodActivity.call(what_do_you_want_to_do_today?: :watch_tv)

    expect(outcome).to be_a(AmazingActivist::Outcome::Failure)
    expect(outcome.code).to be(:bad_choice)
  end
end
