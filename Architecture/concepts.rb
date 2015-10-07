=begin
  Authors:
    Jose Manuel Salinas Teran     A01167907
    Diego Galíndez Barreda        A01370815
=end

=begin
  Here we make a Motor class, which will be mixed 
  into both the car and airplane class.
  This also helps us show how encapsulation works.
=end
class Motor
  def initialize(type)
    if (type == :gas)
      @type = "Gas motor"
      @cylinders = 6
    elsif (type == :turbosine)
      @type = "Turbosine motor"
      @cylinders = 9001
    else
      @type = "You cheater!"
      @cylinders = -1
    end
  end

  # Here we 'return' a small string with the desired information
  def show_specs 
    "#{@type} with #{@cylinders} cylinders."
  end
end

=begin
  Here we make a Vehicle class.
  Both the car and airplane classes will inherit from it.
=end
class Vehicle
  def initialize(name, passengers, type)
    @name = name
    @passengers = passengers
    @engine = Motor.new(type)
  end

 def move
    puts "#{@name} is moving!!! It has a #{@engine.show_specs}"
  end
end

=begin
  Here we make a Car class which inherits from Vehicle.
=end
class Car < Vehicle
  def initialize(name, brand)
    super(name, 4, :gas)
    @brand = brand
  end

  def move 
    puts "Car with brand #{@brand} and name #{@name} is moving!!! It has a #{@engine.show_specs}"
  end
end

=begin
  Here we make an Airplane class which inherits from Vehicle.
  We do not implement a "move" method here, to show 
  polymorphism (since it is a vehicle it can move still) and inheritance.
=end
class Airplane < Vehicle
  def initialize(name, airline)
    super(name, 4, :turbosine)
    @airline = airline
  end
end


# Here we create some instances of each class
fast_car = Car.new("Pony", "Pontiac")
big_car = Car.new("Sedan", "Chrysler")
small_airplane = Airplane.new("777", "Boeing")

# Since they are all Vehicles, they can all move
fast_car.move
big_car.move
small_airplane.move
