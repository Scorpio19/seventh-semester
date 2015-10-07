require 'minitest/autorun'
require 'stringio'
require './student'

class StudentTest < Minitest::Test

  def setup
    @out = StringIO.new
    @old_stdout = $stdout
    $stdout = @out
    @s = Student.new('Jhon', 123, 20_000)
  end

  def teardown
    $stdout = @old_stdout
  end

  def test_reset_anual_income
    assert_equal 20_000, @s.anual_income
    @s.anual_income = 25_000
    assert_equal 25_000, @s.anual_income
  end

  def test_add_grade
    assert_same @s.add_grade(70), @s
  end

  def test_display_summary
    @s.add_grade(80).add_grade(70)
    @s.display_summary
    assert_equal \
      "Name: Jhon ID: 123\n" \
      "Anual income: 20000\n" \
      "Grade average: 75.0\n" \
      "The contents of this class must not be considered an offer,\n" \
      "proposal, understanding or agreement unless it is confirmed\n" \
      "in a document signed by at least five blood-sucking lawyers.\n",
      @out.string
  end

  def test_scholarship_worthy
    assert_raises(RuntimeError) { @s.scholarship_worthy? }
    @s.add_grade(80).add_grade(70)
    refute @s.scholarship_worthy?
    @s.add_grade(100).add_grade(100)
    refute @s.scholarship_worthy?
    @s.anual_income = 11_000
    assert @s.scholarship_worthy?
    @s.add_grade(0).add_grade(0)
    refute @s.scholarship_worthy?
  end
end
