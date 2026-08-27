# Hablaba

[![CI](https://github.com/adriand/hablaba/actions/workflows/ci.yml/badge.svg)](https://github.com/adriand/hablaba/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/hablaba.svg)](https://rubygems.org/gems/hablaba)

Hablaba conjugates regular Spanish verbs in seven tenses. Pure Ruby, no runtime
dependencies.

## Installation

```sh
gem install hablaba
```

Or in a Gemfile:

```ruby
gem "hablaba"
```

## Usage

```ruby
require "hablaba"

Hablaba.conjugate("yo", "hablar")                    # => "hablo"
Hablaba.conjugate("yo", "hablar", :preterite)        # => "hablé"
Hablaba.conjugate("nosotros", "comer", :future)      # => "comeremos"
Hablaba.conjugate("ellas", "vivir", :conditional)    # => "vivirían"
```

The tense defaults to `:present`. Arguments are case-insensitive, trimmed of
surrounding whitespace, and never mutated.

### Pronouns

    yo  tú  él  ella  usted  nosotros  vosotros  ellos  ellas  ustedes

Accents are optional (`tu` and `el` work), and the feminine plurals `nosotras`
and `vosotras` are accepted. The full list is available as
`Hablaba::PRONOUNS`, a hash of each spelling to its column in a conjugation
table.

### Tenses

| Tense                    | Example                          |
| ------------------------ | -------------------------------- |
| `:present`               | I *speak* — *hablo*              |
| `:preterite`             | I *spoke* — *hablé*              |
| `:imperfect`             | I *used to speak* — *hablaba*    |
| `:present_subjunctive`   | I hope *that I speak* — *hable*  |
| `:imperfect_subjunctive` | I hoped *that I spoke* — *hablara* |
| `:conditional`           | I *would speak* — *hablaría*     |
| `:future`                | I *will speak* — *hablaré*       |

Also available as `Hablaba::TENSES`.

### Errors

Unrecognized input raises, rather than returning something misleading:

```ruby
Hablaba.conjugate("we", "hablar")            # Hablaba::UnknownPronounError
Hablaba.conjugate("yo", "casa")              # Hablaba::UnknownVerbError
Hablaba.conjugate("yo", "hablar", :pluscuamperfecto) # Hablaba::UnknownTenseError
```

All three inherit from `Hablaba::Error`, so a single `rescue` catches them:

```ruby
begin
  Hablaba.conjugate(pronoun, verb, tense)
rescue Hablaba::Error => e
  warn e.message
end
```

## Limitations

- **Regular verbs only.** Irregular verbs are not detected, so
  `Hablaba.conjugate("yo", "tener")` returns the regular `"teno"`, not
  `"tengo"`. Stem-changing verbs (`pensar` → `pienso`) and orthographic changes
  (`buscar` → `busqué`) are not handled either.
- The imperfect subjunctive returns the `-ra` form (`hablara`), not the `-se`
  form (`hablase`).
- Voseo (`vos hablás`) is not supported.
- Compound tenses, the imperative, and the participles are not supported.

## Development

```sh
bundle install
bundle exec rake test
```

Tests run against Ruby 3.1 through 3.4 in CI. The suite checks the complete
conjugation table — every person, in every tense — for one verb of each
conjugation.

## License

MIT. See [LICENSE](LICENSE).
