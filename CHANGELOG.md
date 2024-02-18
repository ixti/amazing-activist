# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[0.1.0]: https://github.com/ixti/sidekiq-antidote/tree/v0.1.0
