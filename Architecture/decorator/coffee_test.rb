# Decorator Pattern
# Date: 9-Oct-2015
# Authors:
#   A01370815 Diego Galíndez Barreda
#   A01169999 Rodrigo Villalobos Sánchez

# File name: coffee_test.rb
require 'minitest/autorun'
require './coffee'

# If you get a NameError saying that Minitest is an 
# # uninitialized constant, replace Minitest::Test with
# # MiniTest::Unit::TestCase
class CoffeeTest < Minitest::Test

  def test_espresso
    beverage = Espresso.new
    assert_equal("Espresso", beverage.description)
    assert_equal(1.99, beverage.cost)
  end

  def test_dark_roast
    beverage = DarkRoast.new
    beverage = Milk.new(beverage)
    beverage = Mocha.new(beverage)
    beverage = Mocha.new(beverage)
    beverage = Whip.new(beverage)
    assert_equal("Dark Roast Coffee, Milk, Mocha, Mocha, Whip", beverage.description)
    assert_equal(1.59, beverage.cost)
  end

  def test_house_blend
    beverage = HouseBlend.new
    beverage = Soy.new(beverage)
    beverage = Mocha.new(beverage)
    beverage = Whip.new(beverage)
    assert_equal("House Blend Coffee, Soy, Mocha, Whip", beverage.description)
    assert_equal(1.34, beverage.cost)
  end

end
