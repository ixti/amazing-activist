# frozen_string_literal: true

# @deprecated Use AmazingActivist::Failure
RSpec.describe AmazingActivist::Outcome::Failure do
  it "is a deprecated alias of AmazingActivist::Failure" do
    expect(described_class).to be AmazingActivist::Failure
  end
end
