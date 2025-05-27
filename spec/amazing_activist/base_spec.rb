# frozen_string_literal: true

RSpec.describe AmazingActivist::Base do
  it "provides private `#success` outcome helper" do
    outcome = Pretty::DamnGoodActivity.call(what_do_you_want_to_do_today?: :go_to_the_punk_rock_show)

    expect(outcome).to be_an(AmazingActivist::Success).and have_attributes(
      unwrap!: "YEAH! Let's go to the punk rock show!"
    )
  end

  it "provides private `#failure` outcome helper" do
    outcome = Pretty::DamnGoodActivity.call(what_do_you_want_to_do_today?: :watch_tv)

    expect(outcome).to be_an(AmazingActivist::Failure).and have_attributes(
      code: :bad_choice
    )
  end

  it "provides default `#call` implementation" do
    outcome = Class.new(described_class).call

    expect(outcome).to be_an(AmazingActivist::Failure).and have_attributes(
      code: :not_implemented
    )
  end

  describe ".call" do
    it "delegates execution to #call" do
      activity = Pretty::DamnGoodActivity.__send__(:new)

      allow(Pretty::DamnGoodActivity).to receive(:new).and_return(activity)
      allow(activity).to receive(:call).and_call_original

      Pretty::DamnGoodActivity.call(rancid: "New face of rock'n'roll")

      expect(Pretty::DamnGoodActivity).to have_received(:new)
      expect(activity).to have_received(:call)
    end

    context "when outcome contract is broken" do
      it "fails with BrokenContractError" do
        expect { BrokenContractActivity.call }
          .to raise_error(AmazingActivist::BrokenContractError)
      end
    end

    context "when `#call` fails with UnwrapError" do
      it "returns original failure" do
        activity_class = Class.new(described_class) do
          def call = failure(:nope).unwrap!
        end

        expect(activity_class.call).to be_failure.and have_attributes(code: :nope)
      end
    end

    context "when `#call` fails with unhandled exception" do
      it "does not intercept it" do
        expect { UnhandledExceptionActivity.call }.to raise_error(RuntimeError)
      end
    end
  end

  describe ".on_broken_outcome" do
    it "requires block" do
      expect { Class.new(described_class) { on_broken_outcome } }
        .to raise_error(ArgumentError, %r{block required})
    end

    it "registers custom handler for the broken outcome" do
      expect(BrokenContractActivity::WithHandler.call)
        .to be_success.and have_attributes(unwrap!: 42)
    end

    it "respects parent's broken outcome handler" do
      expect(Class.new(BrokenContractActivity::WithHandler).call)
        .to be_success.and have_attributes(unwrap!: 42)
    end

    it "allows overiding parent's broken outcome handler" do
      expect(BrokenContractActivity::WithHandlerOverride.call)
        .to be_failure.and have_attributes(code: :broken_contract, context: { value: 42 })
    end
  end

  describe ".rescue_from" do
    it "requires block" do
      expect { Class.new(described_class) { rescue_from("StandardError") } }
        .to raise_error(ArgumentError, %r{Handler block required})
    end

    it "requires valid String or Module list of classes" do
      expect { Class.new(described_class) { rescue_from("StandardError", 42) { failure(:nope) } } }
        .to raise_error(ArgumentError, %r{42 must be an Exception class or a String referencing a class})
    end

    it "supports Strings and Modules as class names" do
      activity_class = Class.new(UnhandledExceptionActivity) do
        rescue_from StandardError, "ScriptError" do |exception|
          failure(:unhandled_exception, exception: exception)
        end
      end

      expect(activity_class.call(error_class: RuntimeError))
        .to be_failure
        .and have_attributes(
          code:      :unhandled_exception,
          exception: an_instance_of(RuntimeError)
        )

      expect(activity_class.call(error_class: SyntaxError))
        .to be_failure
        .and have_attributes(
          code:      :unhandled_exception,
          exception: an_instance_of(SyntaxError)
        )
    end

    it "registers rescue handlers" do
      expect(UnhandledExceptionActivity::WithHandler.call(error_class: RuntimeError))
        .to be_failure
        .and have_attributes(
          code:      :unhandled_exception,
          exception: an_instance_of(RuntimeError)
        )

      expect(UnhandledExceptionActivity::WithHandler.call(error_class: StandardError))
        .to be_failure
        .and have_attributes(
          code:      :unhandled_exception,
          exception: an_instance_of(StandardError)
        )

      expect { UnhandledExceptionActivity::WithHandler.call(error_class: ScriptError) }
        .to raise_error(ScriptError)
    end

    it "respects parent's rescue handlers" do
      expect(UnhandledExceptionActivity::WithHandlerOverride.call(error_class: RuntimeError))
        .to be_success
        .and have_attributes(unwrap!: 42)

      expect(UnhandledExceptionActivity::WithHandlerOverride.call(error_class: StandardError))
        .to be_failure
        .and have_attributes(
          code:      :unhandled_exception,
          exception: an_instance_of(StandardError)
        )

      expect { UnhandledExceptionActivity::WithHandlerOverride.call(error_class: ScriptError) }
        .to raise_error(ScriptError)
    end
  end
end
