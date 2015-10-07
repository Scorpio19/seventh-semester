#==========================================================
# Diego Galindez Barreda A01370815
#==========================================================

require 'minitest/autorun'
require 'observer'
require 'stringio'

#==========================================================
# Code for Question 1

#----------------------------------------------------------
# Place here your code for these classes: Cruncher,
# TextCrucher, and BinaryCruncher.
#----------------------------------------------------------

class Cruncher
  def initialize(input_file_name, output_file_name)
    @input = input_file_name
    @output = output_file_name
  end

  def crunch
    read_data
    process_data
    write_data
  end
  
  def process_data
    @numbers.sort!
    size = @numbers.size
    sum = @numbers.inject(:+)
    @mean = sum.to_f / size
    @median = if size % 2 == 0
               (@numbers[size / 2] + @numbers[size / 2 - 1]) / 2.0
             else
               @numbers[size / 2].to_f
             end
    freq = @numbers.inject(Hash.new(0)) {|h, v| h[v] += 1; h }
    @mode = @numbers.max_by {|v| freq[v]}.to_f
    @stdevp = Math.sqrt(@numbers.map{|x| (x - @mean) ** 2}.inject(:+) / @numbers.size)
  end

end

class TextCruncher < Cruncher
  def read_data
    @numbers = File.read(@input).split.map(& :to_i)
  end

  def write_data
    File.write(@output, "#{ @mean } #{ @median } #{ @mode } #{ @stdevp }")
  end
end

class BinaryCruncher < Cruncher
  def read_data
    @numbers = File.binread(@input).unpack('l<*')
  end

  def write_data
    output = [@mean, @median, @mode, @stdevp]
    File.write(@output, output.pack('E*'))
  end
end

# If you get a NameError saying that Minitest is an
# uninitialized constant, replace Minitest::Test with
# MiniTest::Unit::TestCase
class CruncherTest < Minitest::Test

  def test_text_cruncher
    c = TextCruncher.new('input_data.txt', 'output_data.txt')
    c.crunch
    assert_equal File.read('expected_output_data.txt'), File.read('output_data.txt')
  end

  def test_binary_cruncher
    c = BinaryCruncher.new('input_data.bin', 'output_data.bin')
    c.crunch
    assert_equal File.binread('expected_output_data.bin'), File.binread('output_data.bin')
  end
end

#==========================================================
# Code for Question 2

class Parent

  include Observable

  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Child

  attr_reader :name

  def initialize(name, parent)
    @name = name
    @parent = parent 
    @parent.add_observer(self)
  end

  def say(m)
    puts "#{@name} said \"#{m}\""
    @parent.changed
    @parent.notify_observers(m, self)
  end

  def update(m, x)
    if (x != self)
      puts "#{@parent.name} told #{@name} that #{x.name} said \"#{m}\""
    end
  end
end

#----------------------------------------------------------
# Place here your code for these classes: Parent and
# Child.
#----------------------------------------------------------

# If you get a NameError saying that Minitest is an
# uninitialized constant, replace Minitest::Test with
# MiniTest::Unit::TestCase
class ParentChildTest < Minitest::Test

  def setup
    @out = StringIO.new
    @old_stdout = $stdout
    $stdout = @out
  end

  def teardown
    $stdout = @old_stdout
  end

  def test_parent_child
    p = Parent.new('Scarlet')
    c1 = Child.new('Kevin', p)
    c2 = Child.new('Stuart', p)
    c3 = Child.new('Bob', p)
    c1.say('Tulaliloo ti amo!')
    c2.say('Me want banana!')
    c3.say('Bee Do Bee Do Bee Do!')
    assert_equal "Kevin said \"Tulaliloo ti amo!\"\n"                            \
                 "Scarlet told Stuart that Kevin said \"Tulaliloo ti amo!\"\n"   \
                 "Scarlet told Bob that Kevin said \"Tulaliloo ti amo!\"\n"      \
                 "Stuart said \"Me want banana!\"\n"                             \
                 "Scarlet told Kevin that Stuart said \"Me want banana!\"\n"     \
                 "Scarlet told Bob that Stuart said \"Me want banana!\"\n"       \
                 "Bob said \"Bee Do Bee Do Bee Do!\"\n"                          \
                 "Scarlet told Kevin that Bob said \"Bee Do Bee Do Bee Do!\"\n"  \
                 "Scarlet told Stuart that Bob said \"Bee Do Bee Do Bee Do!\"\n",
                 @out.string
  end
end
