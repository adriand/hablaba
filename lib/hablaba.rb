# frozen_string_literal: true

require_relative "hablaba/version"

# Hablaba conjugates regular Spanish verbs in seven tenses.
#
#   Hablaba.conjugate("yo", "hablar")                 # => "hablo"
#   Hablaba.conjugate("nosotros", "comer", :future)   # => "comeremos"
#
# Only regular verbs are supported. Irregular verbs are not detected, so
# Hablaba.conjugate("yo", "tener") returns the regular form "teno", not "tengo".
class Hablaba
  # Base class for every error Hablaba raises.
  class Error < StandardError; end

  # Raised when the pronoun is not one Hablaba recognizes.
  class UnknownPronounError < Error; end

  # Raised when the verb is not an infinitive ending in -ar, -er or -ir.
  class UnknownVerbError < Error; end

  # Raised when the tense is not one Hablaba supports.
  class UnknownTenseError < Error; end

  # Every accepted pronoun, mapped to its column in a conjugation table
  # (0 = first person singular through 5 = third person plural). Unaccented
  # spellings are accepted so callers do not need a Spanish keyboard.
  PRONOUNS = {
    "yo" => 0,
    "tú" => 1, "tu" => 1,
    "él" => 2, "el" => 2, "ella" => 2, "usted" => 2,
    "nosotros" => 3, "nosotras" => 3,
    "vosotros" => 4, "vosotras" => 4,
    "ellos" => 5, "ellas" => 5, "ustedes" => 5
  }.freeze

  # Supported tenses, in the order they appear in the README.
  TENSES = %i[
    present preterite imperfect present_subjunctive
    imperfect_subjunctive conditional future
  ].freeze

  # The three regular infinitive endings.
  INFINITIVE_ENDINGS = %w[ar er ir].freeze

  # Endings that attach to the stem (the infinitive minus -ar/-er/-ir).
  STEM_ENDINGS = {
    present: {
      "ar" => %w[o as a amos áis an],
      "er" => %w[o es e emos éis en],
      "ir" => %w[o es e imos ís en]
    },
    preterite: {
      "ar" => %w[é aste ó amos asteis aron],
      "er" => %w[í iste ió imos isteis ieron],
      "ir" => %w[í iste ió imos isteis ieron]
    },
    imperfect: {
      "ar" => %w[aba abas aba ábamos abais aban],
      "er" => %w[ía ías ía íamos íais ían],
      "ir" => %w[ía ías ía íamos íais ían]
    },
    present_subjunctive: {
      "ar" => %w[e es e emos éis en],
      "er" => %w[a as a amos áis an],
      "ir" => %w[a as a amos áis an]
    }
  }.freeze

  # Endings that attach to the whole infinitive rather than the stem.
  INFINITIVE_ENDINGS_BY_TENSE = {
    conditional: %w[ía ías ía íamos íais ían],
    future: %w[é ás á emos éis án]
  }.freeze

  # The imperfect subjunctive is built from the third person plural preterite
  # with its -ron dropped: hablaron -> habla-, comieron -> comie-. Only the
  # nosotros form carries an accent, so each ending has a plain and an
  # accented variant.
  IMPERFECT_SUBJUNCTIVE_LINKS = {
    "ar" => %w[a á],
    "er" => %w[ie ié],
    "ir" => %w[ie ié]
  }.freeze
  private_constant :IMPERFECT_SUBJUNCTIVE_LINKS

  IMPERFECT_SUBJUNCTIVE_ENDINGS = %w[ra ras ra ramos rais ran].freeze
  private_constant :IMPERFECT_SUBJUNCTIVE_ENDINGS

  # The one person whose imperfect subjunctive form is accented.
  NOSOTROS = 3
  private_constant :NOSOTROS

  class << self
    # Conjugate a regular Spanish verb.
    #
    # Example:
    #   >> Hablaba.conjugate("yo", "hablar")
    #   => "hablo"
    #
    # Arguments:
    #   pronoun: (String) one of PRONOUNS, in any case, with or without accents
    #   verb:    (String) an infinitive ending in -ar, -er or -ir
    #   tense:   (Symbol) one of TENSES, defaults to :present
    #
    # Raises UnknownPronounError, UnknownVerbError or UnknownTenseError when
    # an argument is not recognized.
    def conjugate(pronoun, verb, tense = :present)
      person = person_for(pronoun)
      infinitive = normalize(verb, "verb")
      ending = infinitive_ending(infinitive)
      stem = infinitive[0..-3]

      if (endings_by_ending = STEM_ENDINGS[tense])
        stem + endings_by_ending.fetch(ending)[person]
      elsif (endings = INFINITIVE_ENDINGS_BY_TENSE[tense])
        infinitive + endings[person]
      elsif tense == :imperfect_subjunctive
        imperfect_subjunctive(person, ending, stem)
      else
        raise UnknownTenseError,
              "#{tense.inspect} is not a supported tense; expected one of #{TENSES.join(', ')}"
      end
    end

    private

    def person_for(pronoun)
      key = normalize(pronoun, "pronoun")
      PRONOUNS.fetch(key) do
        raise UnknownPronounError,
              "#{pronoun.inspect} is not a supported pronoun; expected one of #{PRONOUNS.keys.join(', ')}"
      end
    end

    def infinitive_ending(infinitive)
      ending = infinitive[-2, 2]
      return ending if INFINITIVE_ENDINGS.include?(ending)

      raise UnknownVerbError,
            "#{infinitive.inspect} is not an infinitive; expected a verb ending in -ar, -er or -ir"
    end

    def imperfect_subjunctive(person, ending, stem)
      plain, accented = IMPERFECT_SUBJUNCTIVE_LINKS.fetch(ending)
      link = person == NOSOTROS ? accented : plain
      stem + link + IMPERFECT_SUBJUNCTIVE_ENDINGS[person]
    end

    # Downcase, trim, and compose accents so that a decomposed "e" + combining
    # acute (which is what some keyboards and macOS filenames produce) matches
    # the precomposed "é" used in the tables above.
    def normalize(word, label)
      unless word.respond_to?(:to_str)
        raise ArgumentError, "#{label} must be a String, got #{word.class}"
      end

      word.to_str.unicode_normalize(:nfc).strip.downcase
    end
  end
end
