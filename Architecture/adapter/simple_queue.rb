# Adapter Pattern
# Date: 02-Oct-2015
# Authors:
#   A01370815 Diego Galíndez Barreda
#   A01169999 Rodrigo Villalobos Sánchez

# File name: simple_queue.rb

# IMPORTANT: Do not modify the following class in any way!

class SimpleQueue

  def initialize
    @info =[]
  end

  def insert(x)
    @info.push(x)
    self
  end

  def remove
    if empty?
      raise "Can't remove if queue is empty"
    else
      @info.shift
    end
  end

  def empty?
    @info.empty?
  end

  def size
    @info.size
  end

  def inspect
    @info.inspect
  end

end
