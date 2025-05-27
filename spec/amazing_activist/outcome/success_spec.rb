# frozen_string_literal: true

# @deprecated Use AmazingActivist::Success
RSpec.describe AmazingActivist::Outcome::Success do
  it "is a deprecated alias of AmazingActivist::Success" do
    expect(described_class).to be AmazingActivist::Success
  end
end
