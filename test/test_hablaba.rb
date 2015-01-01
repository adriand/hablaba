require 'minitest/autorun'
require 'hablaba'

class HablabaTest < Minitest::Test

  def test_ar_present
    assert_equal "hablo", Hablaba.conjugate("yo", "hablar")
  end

  def test_ar_preterite
    assert_equal "hablé", Hablaba.conjugate("yo", "hablar", :preterite)
  end

  def test_ar_imperfect
    assert_equal "hablaba", Hablaba.conjugate("yo", "hablar", :imperfect)
  end

  def test_er_present
    assert_equal "rompo", Hablaba.conjugate("yo", "romper")
  end

  def test_er_preterite
    assert_equal "rompí", Hablaba.conjugate("yo", "romper", :preterite)
  end

  def test_er_imperfect
    assert_equal "rompía", Hablaba.conjugate("yo", "romper", :imperfect)
  end

  def test_ir_present
    assert_equal "abro", Hablaba.conjugate("yo", "abrir")
  end

  def test_ir_preterite
    assert_equal "abrí", Hablaba.conjugate("yo", "abrir", :preterite)
  end

  def test_ir_imperfect
    assert_equal "abría", Hablaba.conjugate("yo", "abrir", :imperfect)
  end

  def test_case_insensitivity
    assert_equal "hablo", Hablaba.conjugate("YO", "Hablar")
  end

end
