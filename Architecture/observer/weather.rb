#encoding: UTF-8

# Observer Pattern
# Date: 28-Aug-2015
# Authors:
#   A01370815 Diego Galíndez Barreda
#   A01169999 Rodrigo Villalobos Sánchez

# File name: weather.rb

require 'observer'

class WeatherData

  include Observable

  def set_measurements(temperature, humidity, pressure)
    changed
    notify_observers(temperature, humidity, pressure)
  end
end

class CurrentConditionsDisplay
  def update(temperature, humidity, pressure)
    puts "Current conditions: #{'%.1f' % temperature}°F and #{'%.1f' % humidity}% humidity"
  end
end

class StatisticsDisplay
  def initialize
    @max = Float::INFINITY * -1
    @min = Float::INFINITY
    @total = 0
    @amount = 0
  end

  def update(temperature, humidity, pressure)

    if (temperature > @max)
      @max = temperature
    end

    if (temperature < @min)
      @min = temperature
    end

    @amount += 1
    @total += temperature

    puts "Avg/Max/Min temperature = #{'%.1f' % (@total/@amount)}/#{'%.1f' % @max}/#{'%.1f' % @min}"

  end

end

class ForecastDisplay
  def initialize
    @previous = 0
  end

  def update(temperature, humidity, pressure)
    if (@previous < pressure)
      puts "Forecast: Improving weather on the way!"
    elsif (@previous > pressure)
      puts "Forecast: Watch out for cooler, rainy weather"
    else
      puts "Forecast: More of the same"
    end
    @previous = pressure
  end
end
