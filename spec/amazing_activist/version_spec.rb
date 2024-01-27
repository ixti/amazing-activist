# frozen_string_literal: true

RSpec.describe "AmazingActivist::VERSION" do
  subject { AmazingActivist::VERSION }

  it { is_expected.to be_a(String).and match(%r{\A\d+(\.\d+){2}}) }
end
