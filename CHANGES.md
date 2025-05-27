# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- (BREAKING) Switch to Zeitwerk autoloader.
- (BREAKING) Deprecate `AmazingActivist::Outcome::{Success,Failure}`
  in favour of `AmazingActivist::Success` and `AmazingActivist::Failure`
  respectively.

## [0.8.0] - 2025-05-01

### Changed

- (BREAKING) Prohibit `AmazingActivist::Base#new` calls. All activities must be
  called via `.call`, i.e. `A.call(...)` instead of `A.new(...).call`.

### Removed

- (BREAKING) Don't provide default catch-all `params` prop.


## [0.7.0] - 2025-04-14

### Added

- Use [literal](https://github.com/joeldrapper/literal) gem to aid inputs
  boilerplate.

### Changed

- (BREAKING) Drop support of Ruby-3.0.X, and Ruby-3.1.X


## [0.6.0] - 2024-12-15

### Added

- Support Ruby-3.4.X.
- Add `Success#inspect` and `Failure#inspect` methods.
- Support default value literal in `Failure#value_or`.

### Changed

- (BREAKING) `Success#value_or` requries default value or block to keep it
  consistent with `Failure#value_or`.


## [0.5.2] - 2024-08-30

### Changed

- i18n now looks for keys without `amazing_activist` prefix as well; Lookup
  order now goes like: `amazing_activist.activities.[activity].failures`,
  `activities.[activity].failures`, `amazing_activist.failures`,
  `activities.failures`, with fallback to hardcoded `"<[activity]> failed - [code]"`.


## [0.5.1] - 2024-04-26

### Changed

- Optimize `Failure#deconstruct_keys` to avoid message generation if requested
  keys are present and do not include it.


## [0.5.0] - 2024-03-13

### Changed

- (BREAKING) i18n does not remove `_activity` suffix from keys anymore, e.g.
  for `Foo::BarActivity` expected i18n key will be `foo/bar_activity`, not
  `foo/bar` as it was before.


## [0.4.0] - 2024-02-19

### Added

- `Base.on_broken_outcome` allows registering custom handler for the broken
  outcome contract (when `#call` returns neither `Success` nor `Failure`)
- `Base.rescue_from` allows registering unhandled exception handlers.


## [0.3.0] - 2024-02-19

### Added

- `UnwrapError#cause` respects failure's `#exception`.

### Changed

- (BREAKING) `Base#failure` context must be given as keyword argument.
- (BREAKING) `Failure#message` is no longer part of its `#context`.
- (BREAKING) `Failure#exception` is no longer part of its `#context`.


## [0.2.0] - 2024-01-28

### Added

- Generate default failure messages with
  [i18n](https://github.com/ruby-i18n/i18n).


## [0.1.0] - 2024-01-27

### Added

- Initial release.

[Unreleased]: https://github.com/ixti/amazing-activist/compare/v0.8.0...main
[0.8.0]: https://github.com/ixti/amazing-activist/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/ixti/amazing-activist/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/ixti/amazing-activist/compare/v0.5.2...v0.6.0
[0.5.2]: https://github.com/ixti/amazing-activist/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/ixti/amazing-activist/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/ixti/amazing-activist/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/ixti/amazing-activist/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/ixti/amazing-activist/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/ixti/amazing-activist/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/ixti/amazing-activist/tree/v0.1.0
