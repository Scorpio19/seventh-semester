#==========================================================
# Diego Galindez Barreda  A01370815
#==========================================================

require 'minitest/autorun'
require 'stringio'

#==========================================================
# Problem 1

class Duck

  def quack
    puts "Quack"
  end

  def fly
    puts "I'm flying"
  end

end

class Turkey

  def gobble
    puts "Gobble gobble"
  end

  def fly
    puts "I'm flying a short distance"
  end

end

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
class TurkeyAdapter
  def initialize(t)
    @turkey = t;
  end

  def quack
    @turkey.gobble
  end

  def fly
    5.times do
      @turkey.fly
    end
  end
end
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# If you get a NameError saying that Minitest is an
# uninitialized constant, replace Minitest::Test with
# MiniTest::Unit::TestCase
class Problem1Test < Minitest::Test

  def setup
    @old_stdout = $stdout
    @out = $stdout = StringIO.new
  end

  def teardown
    $stdout = @old_stdout
  end

  def do_duck_thingies(x)
    x.quack
    x.fly
  end

  def test_turkey_adapter
    duck = Duck.new
    turkey = Turkey.new
    turkey_adapter = TurkeyAdapter.new(turkey)
    do_duck_thingies(duck)
    do_duck_thingies(turkey_adapter)
    assert_equal                        \
      "Quack\n"                         \
      "I'm flying\n"                    \
      "Gobble gobble\n"                 \
      "I'm flying a short distance\n"   \
      "I'm flying a short distance\n"   \
      "I'm flying a short distance\n"   \
      "I'm flying a short distance\n"   \
      "I'm flying a short distance\n",  \
      @out.string
  end

end

#==========================================================
# Problem 2

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
def divisors(n)
  nums = []
  n.times do |i|
    if i == 0
      next
    elsif n % i == 0
      nums << i
    end
  end
  nums << n
  nums.to_enum
end
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# If you get a NameError saying that Minitest is an
# uninitialized constant, replace Minitest::Test with
# MiniTest::Unit::TestCase
class Problem2Test < Minitest::Test

  def do_iterator_thingies(n, expected_values)

    itr = divisors(n)

     # itr should be an instance of the Enumerator class.
    assert itr.instance_of?(Enumerator)

    # itr should work as an external iterator.
    expected_values.each do |value|
      assert_equal value, itr.next
    end

    assert_raises StopIteration do
      itr.next
    end

    # itr should work as an internal iterator.
    itr.each_with_index do |element, index|
      assert_equal expected_values[index], element
    end

  end

  def test_divisors
    do_iterator_thingies 1, [1]
    do_iterator_thingies 12, [1, 2, 3, 4, 6, 12]
    do_iterator_thingies 666, [1, 2, 3, 6, 9, 18, 37, 74, 111, 222, 333, 666]
    do_iterator_thingies 7919, [1, 7919]
  end

end

#==========================================================
# Problem 3

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
def body_mass_index(weight, height)
  bmi = weight.to_f / (height ** 2)

  return :underweight if bmi < 20
  return :normal if bmi < 25
  return :obese1 if bmi < 30
  return :obese2 if bmi < 40
  return :obese3
end
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

class Problem3Test < Minitest::Test

  def test_body_mass_index
    assert_equal :underweight, body_mass_index(45, 1.8)
    assert_equal :normal, body_mass_index(62, 1.6)
    assert_equal :obese1, body_mass_index(85, 1.75)
    assert_equal :obese2, body_mass_index(115, 1.9)
    assert_equal :obese3, body_mass_index(123, 1.58)
  end

end

#==========================================================
# Problem 4

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
class PowersOfTwo

  # Refactor this class.

  def initialize(n)
    @n = n
  end

  def powers
    @powers ||= compute_powers_of_two(@n)
  end

  private

  def compute_powers_of_two(n)
    x = 1
    result = []
    n.times do
      result << x
      x *= 2
    end
    result
  end

end
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

class Problem4Test < Minitest::Test

  def test_powers_of_two
    assert_equal [], PowersOfTwo.new(0).powers
    assert_equal [1], PowersOfTwo.new(1).powers
    assert_equal [1, 2, 4, 8], PowersOfTwo.new(4).powers
    assert_equal [1, 2, 4, 8, 16, 32, 64, 128, 256, 512], PowersOfTwo.new(10).powers
  end

end
