# frozen_string_literal: true

RSpec.describe AmazingActivist::Contractable do
  it "allows specifying input arguments" do
    expect(Pretty::ParameterizedActivity.call(code: :foo, name: "bar"))
      .to be_an(AmazingActivist::Success)
      .and have_attributes(unwrap!: { code: :foo, name: "bar" })

    # TODO: Provide configurable behaviour upon invalid input
    expect { Pretty::ParameterizedActivity.call }
      .to raise_error(ArgumentError, %r{:code})

    # TODO: Provide configurable behaviour upon invalid input
    expect { Pretty::ParameterizedActivity.call(code: :foo, oopsie: 42) }
      .to raise_error(ArgumentError, %r{:oopsie})
  end

  it "allows overriding parent input arguments" do
    expect(Pretty::InheritedParameterizedActivity.call(code: 42, name: "foo", details: "bar"))
      .to be_an(AmazingActivist::Success)
      .and have_attributes(unwrap!: { code: 42, name: "foo", details: "bar" })

    # TODO: Provide configurable behaviour upon invalid input
    expect { Pretty::InheritedParameterizedActivity.call }
      .to raise_error(ArgumentError, %r{:code, :details})

    # TODO: Provide configurable behaviour upon invalid input
    expect { Pretty::InheritedParameterizedActivity.call(code: 42, details: "bar", oopsie: 42) }
      .to raise_error(ArgumentError, %r{:oopsie})
  end
end
