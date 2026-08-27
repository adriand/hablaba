# Changelog

All notable changes to this project are documented here. This project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-08-27

First release in a decade. The conjugations are unchanged; everything around
them was rebuilt.

### Added

- `Hablaba::Error` and its subclasses `UnknownPronounError`,
  `UnknownVerbError` and `UnknownTenseError`, so bad input fails with a message
  that says what was wrong.
- Unaccented pronoun spellings (`tu`, `el`) and the feminine plurals
  (`nosotras`, `vosotras`), for callers without a Spanish keyboard.
- Public `Hablaba::PRONOUNS` and `Hablaba::TENSES` constants.
- `Hablaba::VERSION`.
- Input is Unicode-normalized, so a decomposed `e` + combining acute accent is
  accepted wherever `é` is.
- Surrounding whitespace in arguments is ignored.
- A GitHub Actions build running the tests on Ruby 3.1 through 3.4 and head.
- Full conjugation tables for one verb of each conjugation in the test suite:
  every person, in every tense.

### Changed

- **Breaking:** unrecognized input raises instead of returning `nil` or
  crashing with an internal `TypeError`/`NoMethodError`. An unknown tense used
  to return `nil` silently.
- **Breaking:** a pronoun must now be an exact match. `"yolanda"` previously
  conjugated as `yo`, and `"él mismo"` crashed.
- Requires Ruby >= 3.1.
- The conjugation logic is now a set of lookup tables rather than one method
  per tense per verb ending.

### Fixed

- User input is no longer interpolated into a regular expression.
- Arguments are never mutated, and frozen strings are accepted.

## [0.0.4] - 2015-12-09

- Added the imperfect subjunctive and the accented `nosotros` form.

## [0.0.3] - 2015-12-08

- Added the present subjunctive, conditional and future tenses.

## [0.0.2] - 2014-12-31

- Made the pronoun and verb arguments case-insensitive.

## [0.0.1] - 2014-12-31

- Initial release: present, preterite and imperfect tenses.

[1.0.0]: https://github.com/adriand/hablaba/releases/tag/v1.0.0
