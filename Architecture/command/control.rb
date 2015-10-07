# Command Pattern
# Date: 18-September-2015
# Authors:
#   A01370815 Diego Galíndez Barreda
#   A01169999 Rodrigo Villalobos Sánchez

# File name: control.rb

class RemoteControlWithUndo

  def initialize
    @on_commands = []
    @off_commands = []
    no_command = NoCommand.new
    7.times do
      @on_commands << no_command
      @off_commands << no_command
    end
    @undo_command = no_command
  end

  def set_command(slot, on_command, off_command)
    @on_commands[slot] = on_command
    @off_commands[slot] = off_command
  end

  def on_button_was_pushed(slot)
    @on_commands[slot].execute
    @undo_command = @on_commands[slot]
  end

  def off_button_was_pushed(slot)
    @off_commands[slot].execute
    @undo_command = @off_commands[slot]
  end

  def undo_button_was_pushed()
    @undo_command.undo
  end

  def inspect
    string_buff = ["\n------ Remote Control -------\n"]
    @on_commands.zip(@off_commands).each_with_index do |commands, i|
      on_command, off_command = commands
      string_buff << "[slot #{i}] #{on_command.class}  #{off_command.class}\n"
    end
    string_buff << "[undo] #{@undo_command.class}\n"
    string_buff.join
  end

end

class NoCommand

  def execute
  end

  def undo
  end

end

class Light

  attr_reader :level

  def initialize(location)
    @location = location
    @level = 0
  end

  def on
    @level = 100
    puts "Light is on"
  end

  def off
    @level = 0
    puts "Light is off"
  end

  def dim(level)
    @level = level
    if level == 0
      off
    else
      puts "Light is dimmed to #{@level}%"
    end
  end

end

class CeilingFan

  # Access these constants from outside this class as CeilingFan::HIGH,
  # CeilingFan::MEDIUM, and so on.  
  HIGH   = 3
  MEDIUM = 2
  LOW    = 1
  OFF    = 0

  attr_reader :speed

  def initialize (location)
    @location = location
    @speed = OFF
    @previous_speed = []
  end

  def high
    @previous_speed << @speed
    @speed = HIGH;
    puts "#{@location} ceiling fan is on high"
  end

  def medium
    @previous_speed << @speed
    @speed = MEDIUM
    puts "#{@location} ceiling fan is on medium"
  end

  def low
    @previous_speed << @speed
    @speed = LOW
    puts "#{@location} ceiling fan is on low"
  end

  def off
    @previous_speed << @speed
    @speed = OFF
    puts "#{@location} ceiling fan is off"
  end

  def get_last
    @previous_speed.pop
  end

end

class LightOnCommand

  def initialize(light)
    @light = light
  end

  def execute
    @light.on
  end

  def undo
    if @light.level == 0
      @light.on
    else
      @light.off
    end
  end

end

class LightOffCommand

  def initialize(light)
    @light = light
  end

  def execute
    @light.off
  end

  def undo
    if @light.level == 0
      @light.on
    else
      @light.off
    end
  end

end

class CeilingFanCommand
  def initialize(fan)
    @fan = fan
  end

  def undo
    previous_speed = @fan.get_last
    case previous_speed
      when CeilingFan::OFF
        @fan.off
      when CeilingFan::LOW
        @fan.low
      when CeilingFan::MEDIUM
        @fan.medium
      when CeilingFan::HIGH
        @fan.high
      else
        # There are no previous instructions
        @fan.off
      end
  end

end

class CeilingFanHighCommand < CeilingFanCommand

  def execute
    @fan.high
  end

end

class CeilingFanMediumCommand < CeilingFanCommand

  def execute
    @fan.medium
  end

end

class CeilingFanOffCommand < CeilingFanCommand

  def execute
    @fan.off
  end

end
