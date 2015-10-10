# File: tigger.rb
require 'singleton'

class Tigger
  include Singleton

  def to_s
    return "I'm the only one!"
  end

  def roar
    'Grrr!'
  end

end
