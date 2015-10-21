#==========================================================
# Diego Galindez Barreda  A01370815
#==========================================================

require 'minitest/autorun'
require 'forwardable'

#
# A collection implemented as a circular doubly-linked
# list.
#
# YOU MUST NOT MODIFY THIS CLASS IN ANY WAY!
#
class LinkedList

  #
  # Individual list nodes.
  #
  class Node
    attr_accessor :prv, :nxt, :data
    def initialize(data=nil, prv=nil, nxt=nil)
      @data = data
      @prv = prv
      @nxt = nxt
    end
  end

  #
  # Creates an empty list.
  #
  def initialize
    @sentinel = Node.new
    @sentinel.prv = @sentinel
    @sentinel.nxt = @sentinel
  end

  #
  # Returns true if this list is empty, otherwise
  # returns false.
  #
  def empty?
    @sentinel.nxt == @sentinel
  end

  #
  # Adds a new element to the start of this list.
  #
  def add_first(e)
    node = Node.new(e, @sentinel, @sentinel.nxt)
    @sentinel.nxt.prv = node
    @sentinel.nxt = node
  end

  #
  # Adds a new element to the end of this list.
  #
  def add_last(e)
    node = Node.new(e, @sentinel.prv, @sentinel)
    @sentinel.prv.nxt = node
    @sentinel.prv = node
  end

  #
  # Removes and returns the element at the start of this
  # list. Return nil if the list is empty.
  #
  def remove_first
    return nil if empty?
    node = @sentinel.nxt
    e = node.data
    node.nxt.prv = @sentinel
    @sentinel.nxt = node.nxt
    e
  end

  #
  # Removes and returns the element at the end of this
  # list. Return nil if the list is empty.
  #
  def remove_last
    return nil if empty?
    node = @sentinel.prv
    e = node.data
    node.prv.nxt = @sentinel
    @sentinel.prv = node.prv
    e
  end

  #
  # Calls the given block once for each element in this
  # list, passing that element as a parameter.
  #
  def each
    node = @sentinel.nxt
    while node != @sentinel
      yield node.data
      node = node.nxt
    end
  end

  #
  # Creates a string representation of this list.
  #
  def to_s
    r = []
    each do |e|
      r << e
    end
    '[' + r.join(', ') + ']'
  end

end # End of class LinkedList.

#----------------------------------------------------------
# Place here your code for the class StackAdapter
# (Problem 1) and its iterator() method (Problem 2).
#----------------------------------------------------------

#----------------------------------------------------------
# Place here your code for the class SizeListDecorator
# (Problem 3).
#----------------------------------------------------------

# If you get a NameError saying that Minitest is an 
# uninitialized constant, replace Minitest::Test with
# MiniTest::Unit::TestCase
class ExamTest < Minitest::Test

  def setup
    @lst = LinkedList.new
    @lst.add_first(15)
    @lst.add_last(16)
    @lst.add_first(8)
    @lst.add_last(23)
    @lst.add_first(4)
    @lst.add_last(42)
  end

  def test_adapter
    lst = LinkedList.new
    stack = StackAdapter.new(lst)
    assert(stack.empty?)
    stack.push(42)
    stack.push(23)
    stack.push(16)
    stack.push(15)
    stack.push(8)
    stack.push(4)
    assert(!stack.empty?)
    assert(!lst.empty?)
    assert_equal('[4, 8, 15, 16, 23, 42]', lst.to_s)
    assert_equal(4, stack.pop)
    assert_equal(8, stack.pop)
    assert_equal(15, stack.pop)
    assert_equal(16, stack.pop)
    assert_equal(23, stack.pop)
    assert_equal(42, stack.pop)
    assert(stack.empty?)
    assert(lst.empty?)

    stack = StackAdapter.new(@lst)
    assert(!stack.empty?)
    assert_equal(4, stack.pop)
    assert_equal(8, stack.pop)
    assert_equal(15, stack.pop)
    stack.push('a')
    stack.push('b')
    stack.push('c')
    assert_equal('[c, b, a, 16, 23, 42]', @lst.to_s)
    assert_equal('c', stack.pop)
    assert_equal('b', stack.pop)
    assert_equal('a', stack.pop)
    assert_equal(16, stack.pop)
    assert_equal(23, stack.pop)
    assert_equal(42, stack.pop)

    assert(stack.empty?)
    assert_raises RuntimeError do
      stack.pop
    end
  end

  def test_iterator
    stack = StackAdapter.new(@lst)
    itr = stack.iterator

    # itr should be an instance of the Enumerator class.
    assert(itr.instance_of?(Enumerator))

    # itr should work as an external iterator.
    assert_equal(4, itr.next)
    assert_equal(8, itr.next)
    assert_equal(15, itr.next)
    assert_equal(16, itr.next)
    assert_equal(23, itr.next)
    itr.rewind
    assert_equal(4, itr.next)
    assert_equal(8, itr.next)
    assert_equal(15, itr.next)
    assert_equal(16, itr.next)
    assert_equal(23, itr.next)
    assert_equal(42, itr.next)
    assert_raises StopIteration do
      itr.next
    end

    stack.push('a')
    stack.push('b')
    stack.push('c')
    itr.rewind
    assert_equal('c', itr.next)
    assert_equal('b', itr.next)
    assert_equal('a', itr.next)
    assert_equal(4, itr.next)
    assert_equal(8, itr.next)
    assert_equal(15, itr.next)
    assert_equal(16, itr.next)
    assert_equal(23, itr.next)
    assert_equal(42, itr.next)
    assert_raises StopIteration do
      itr.next
    end

    # itr should work as an internal iterator.
    data = ['c', 'b', 'a', 4, 8, 15, 16, 23, 42]
    itr.each_with_index do |e, i|
      assert_equal(data[i], e)
    end
  end

  def test_decorator
    deco = SizeListDecorator.new(@lst)
    assert(!deco.is_a?(LinkedList))
    assert(!deco.empty?)
    assert_equal(6, deco.size)
    deco.add_first('x')
    assert_equal(7, deco.size)
    deco.add_last('y')
    assert_equal(8, deco.size)
    assert_equal('[x, 4, 8, 15, 16, 23, 42, y]', deco.to_s)
    assert_equal('[x, 4, 8, 15, 16, 23, 42, y]', @lst.to_s)
    i = 0
    data = ['x', 4, 8, 15, 16, 23, 42, 'y']
    deco.each do |e|
      assert_equal(data[i], e)
      i += 1
    end
    assert_equal('x', deco.remove_first)
    assert_equal(7, deco.size)
    assert_equal(4, deco.remove_first)
    assert_equal(6, deco.size)
    assert_equal(8, deco.remove_first)
    assert_equal(5, deco.size)
    assert_equal('y', deco.remove_last)
    assert_equal(4, deco.size)
    assert_equal(42, deco.remove_last)
    assert_equal(3, deco.size)
    assert_equal(23, deco.remove_last)
    assert_equal(2, deco.size)
    assert_equal('[15, 16]', deco.to_s)
    assert_equal('[15, 16]', @lst.to_s)
    assert_equal(16, deco.remove_last)
    assert_equal(1, deco.size)
    assert_equal(15, deco.remove_last)
    assert_equal(0, deco.size)
    assert(deco.empty?)
    assert_equal('[]', deco.to_s)
    assert_equal('[]', @lst.to_s)
  end

end

class StackAdapter
  def initialize(a)
    @list = a
  end

  def push(e)
    @list.add_first(e)
  end

  def pop
    raise RuntimeError if @list.empty?
    @list.remove_first
  end

  def empty?
    @list.empty?
  end

  def iterator
    Enumerator.new(@list)
  end
end

class SizeListDecorator
  extend Forwardable
  def_delegator :@list, :to_s
  def_delegator :@list, :empty?
  def_delegator :@list, :each

  attr_reader :size

  def initialize(l)
    @list = l
    @size = 0
    @list.each { @size += 1 }
  end

  def add_first(e)
    @list.add_first(e)
    @size += 1
  end

  def add_last(e)
    @size += 1
    @list.add_last(e)
  end

  def add_last(e)
    @size += 1
    @list.add_last(e)
  end

  def remove_first
    @size -= 1
    @list.remove_first
  end

  def remove_last
    @size -= 1
    @list.remove_last
  end
end
