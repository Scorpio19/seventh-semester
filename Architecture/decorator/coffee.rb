# Decorator Pattern
# Date: 9-Oct-2015
# Authors:
#   A01370815 Diego Galíndez Barreda
#   A01169999 Rodrigo Villalobos Sánchez

# File name: coffee.rb
class Beverage
  attr_reader :description, :cost
  def initialize(description, cost)
    @description = description
    @cost = cost
  end
end

class DarkRoast < Beverage
  def initialize
    super("Dark Roast Coffee", 0.99)
  end
end

class Espresso < Beverage
  def initialize
    super("Espresso", 1.99)
  end
end

class HouseBlend < Beverage
  def initialize
    super("House Blend Coffee", 0.89)
  end
end

class CondimentDecorator < Beverage
  def initialize(description, cost, beverage)
    super(description, cost)
    @beverage = beverage
  end

  def description
    "#{@beverage.description}, #{@description}"
  end

  def cost
    @beverage.cost + @cost
  end
end

class Mocha < CondimentDecorator
  def initialize(beverage)
    super("Mocha", 0.20, beverage)
  end
end

class Whip < CondimentDecorator
  def initialize(beverage)
    super("Whip", 0.10, beverage)
  end
end

class Soy < CondimentDecorator
  def initialize(beverage)

    super("Soy", 0.15, beverage)
  end
end

class Milk < CondimentDecorator
  def initialize(beverage)
    super("Milk", 0.10, beverage)
  end
end
