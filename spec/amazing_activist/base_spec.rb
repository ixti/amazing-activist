# frozen_string_literal: true

RSpec.describe AmazingActivist::Base do
  it "provides .call(...) syntax sugar" do
    activity = Pretty::DamnGoodActivity.new

    allow(Pretty::DamnGoodActivity).to receive(:new).and_return(activity)
    allow(activity).to receive(:call).and_call_original

    Pretty::DamnGoodActivity.call(rancid: "New face of rock'n'roll")

    expect(Pretty::DamnGoodActivity).to have_received(:new)
    expect(activity).to have_received(:call)
  end

  it "provides private `#success` outcome helper" do
    outcome = Pretty::DamnGoodActivity.call(what_do_you_want_to_do_today?: :go_to_the_punk_rock_show)

    expect(outcome).to be_an(AmazingActivist::Outcome::Success).and have_attributes(
      unwrap!: "YEAH! Let's go to the punk rock show!"
    )
  end

  it "provides private `#failure` outcome helper" do
    outcome = Pretty::DamnGoodActivity.call(what_do_you_want_to_do_today?: :watch_tv)

    expect(outcome).to be_an(AmazingActivist::Outcome::Failure).and have_attributes(
      code: :bad_choice
    )
  end

  it "provides default `#call` implementation" do
    outcome = Class.new(described_class).call

    expect(outcome).to be_an(AmazingActivist::Outcome::Failure).and have_attributes(
      code: :not_implemented
    )
  end
end
