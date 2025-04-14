# frozen_string_literal: true

RSpec.describe AmazingActivist::Contractable do
  it "allows specifying input arguments" do
    expect(Pretty::ParameterizedActivity.call(code: :foo))
      .to be_an(AmazingActivist::Outcome::Success)
      .and have_attributes(unwrap!: { code: :foo, name: nil, params: {} })

    expect(Pretty::ParameterizedActivity.call(code: :foo, name: "bar", answer: 42))
      .to be_an(AmazingActivist::Outcome::Success)
      .and have_attributes(unwrap!: { code: :foo, name: "bar", params: { answer: 42 } })
  end

  it "allows overriding parent input arguments" do
    expect(Pretty::InheritedParameterizedActivity.call(params: 42))
      .to be_an(AmazingActivist::Outcome::Success)
      .and have_attributes(unwrap!: { code: nil, name: nil, params: 42 })

    # TODO: Provide configurable behaviour upon invalid input
    expect { Pretty::InheritedParameterizedActivity.call(oopsie: 42) }
      .to raise_error(ArgumentError, %r{oopsie})
  end
end
