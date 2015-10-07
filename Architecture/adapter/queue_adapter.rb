# Adapter Pattern
# Date: 02-Oct-2015
# Authors:
#   A01370815 Diego Galíndez Barreda
#   A01169999 Rodrigo Villalobos Sánchez

# File name: queue_adapter.rb

require './simple_queue'
require './queue_adapter'

class QueueAdapter
  def initialize(q)
    @queue = q;
  end

  def push(x)
    temp = []
    temp.push(x)

    while !@queue.empty? do
      temp.push(@queue.remove)
    end

    temp.each do |x|
      @queue.insert(x)
    end

    self
  end

  def pop
    if @queue.empty?
      nil
    else
      @queue.remove
    end
  end

  def peek
    if @queue.empty?
      nil
    else
      value = @queue.remove
      push(value)
      value
    end
  end

  def method_missing(method, *args)
    @queue.send(method)
  end
end
