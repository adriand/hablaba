# frozen_string_literal: true

require "minitest/autorun"
require "hablaba"

class HablabaTest < Minitest::Test
  # One pronoun per person, in table order.
  PERSONS = %w[yo tú él nosotros vosotros ellos].freeze

  # Complete paradigms for one regular verb of each conjugation.
  PARADIGMS = {
    "hablar" => {
      present: %w[hablo hablas habla hablamos habláis hablan],
      preterite: %w[hablé hablaste habló hablamos hablasteis hablaron],
      imperfect: %w[hablaba hablabas hablaba hablábamos hablabais hablaban],
      present_subjunctive: %w[hable hables hable hablemos habléis hablen],
      imperfect_subjunctive: %w[hablara hablaras hablara habláramos hablarais hablaran],
      conditional: %w[hablaría hablarías hablaría hablaríamos hablaríais hablarían],
      future: %w[hablaré hablarás hablará hablaremos hablaréis hablarán]
    },
    "comer" => {
      present: %w[como comes come comemos coméis comen],
      preterite: %w[comí comiste comió comimos comisteis comieron],
      imperfect: %w[comía comías comía comíamos comíais comían],
      present_subjunctive: %w[coma comas coma comamos comáis coman],
      imperfect_subjunctive: %w[comiera comieras comiera comiéramos comierais comieran],
      conditional: %w[comería comerías comería comeríamos comeríais comerían],
      future: %w[comeré comerás comerá comeremos comeréis comerán]
    },
    "vivir" => {
      present: %w[vivo vives vive vivimos vivís viven],
      preterite: %w[viví viviste vivió vivimos vivisteis vivieron],
      imperfect: %w[vivía vivías vivía vivíamos vivíais vivían],
      present_subjunctive: %w[viva vivas viva vivamos viváis vivan],
      imperfect_subjunctive: %w[viviera vivieras viviera viviéramos vivierais vivieran],
      conditional: %w[viviría vivirías viviría viviríamos viviríais vivirían],
      future: %w[viviré vivirás vivirá viviremos viviréis vivirán]
    }
  }.freeze

  PARADIGMS.each do |verb, tenses|
    tenses.each do |tense, expected|
      define_method("test_#{verb}_#{tense}") do
        actual = PERSONS.map { |pronoun| Hablaba.conjugate(pronoun, verb, tense) }
        assert_equal expected, actual
      end
    end
  end

  def test_every_tense_is_covered
    assert_equal Hablaba::TENSES.sort, PARADIGMS.fetch("hablar").keys.sort
  end

  def test_present_is_the_default_tense
    assert_equal "hablo", Hablaba.conjugate("yo", "hablar")
  end

  def test_pronoun_aliases_share_a_person
    { 1 => %w[tú tu],
      2 => %w[él el ella usted],
      3 => %w[nosotros nosotras],
      4 => %w[vosotros vosotras],
      5 => %w[ellos ellas ustedes] }.each_value do |aliases|
      forms = aliases.map { |pronoun| Hablaba.conjugate(pronoun, "hablar") }
      assert_equal 1, forms.uniq.size, "#{aliases.inspect} should conjugate alike, got #{forms.inspect}"
    end
  end

  def test_ustedes_is_third_person_plural_not_usted
    assert_equal "hablan", Hablaba.conjugate("ustedes", "hablar")
    assert_equal "habla", Hablaba.conjugate("usted", "hablar")
  end

  def test_input_is_case_insensitive
    assert_equal "hablo", Hablaba.conjugate("YO", "Hablar")
    assert_equal "habla", Hablaba.conjugate("ÉL", "HABLAR")
  end

  def test_input_is_whitespace_insensitive
    assert_equal "hablo", Hablaba.conjugate("  yo ", " hablar\n")
  end

  def test_decomposed_accents_are_accepted
    decomposed = "e\u0301l" # "el" written as a bare "e" plus a combining acute accent
    refute_equal "\u00E9l", decomposed
    assert_equal "habla", Hablaba.conjugate(decomposed, "hablar")
  end

  def test_frozen_arguments_are_accepted
    assert_equal "hablo", Hablaba.conjugate("yo".freeze, "hablar".freeze)
  end

  def test_arguments_are_not_mutated
    pronoun = +"YO"
    verb = +"Hablar"
    Hablaba.conjugate(pronoun, verb)
    assert_equal "YO", pronoun
    assert_equal "Hablar", verb
  end

  def test_unknown_pronoun_raises
    error = assert_raises(Hablaba::UnknownPronounError) { Hablaba.conjugate("we", "hablar") }
    assert_match(/not a supported pronoun/, error.message)
  end

  def test_a_word_merely_containing_a_pronoun_is_not_a_pronoun
    assert_raises(Hablaba::UnknownPronounError) { Hablaba.conjugate("yolanda", "hablar") }
    assert_raises(Hablaba::UnknownPronounError) { Hablaba.conjugate("él mismo", "hablar") }
  end

  def test_unknown_verb_raises
    error = assert_raises(Hablaba::UnknownVerbError) { Hablaba.conjugate("yo", "casa") }
    assert_match(/not an infinitive/, error.message)
  end

  def test_verb_shorter_than_an_ending_raises
    assert_raises(Hablaba::UnknownVerbError) { Hablaba.conjugate("yo", "a") }
    assert_raises(Hablaba::UnknownVerbError) { Hablaba.conjugate("yo", "") }
  end

  def test_unknown_tense_raises
    error = assert_raises(Hablaba::UnknownTenseError) { Hablaba.conjugate("yo", "hablar", :pluperfect) }
    assert_match(/not a supported tense/, error.message)
  end

  def test_every_error_shares_a_base_class
    [Hablaba::UnknownPronounError, Hablaba::UnknownVerbError, Hablaba::UnknownTenseError].each do |klass|
      assert_operator klass, :<, Hablaba::Error
    end
    assert_operator Hablaba::Error, :<, StandardError
  end

  def test_non_string_arguments_raise_argument_error
    assert_raises(ArgumentError) { Hablaba.conjugate(nil, "hablar") }
    assert_raises(ArgumentError) { Hablaba.conjugate("yo", nil) }
    assert_raises(ArgumentError) { Hablaba.conjugate("yo", :hablar) }
  end

  def test_version_is_present
    assert_match(/\A\d+\.\d+\.\d+/, Hablaba::VERSION)
  end
end
