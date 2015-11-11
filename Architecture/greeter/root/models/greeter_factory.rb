# Activity: The Greeter App
# Date: 26-Nov-2015
# Author: Ariel Ortiz

require 'json'
require './models/greeter'

# The +GreeterFactory+ is an implementation of the {Simple
# Factory Pattern}[https://en.wikipedia.org/wiki/Factory_method_pattern].
# It allows you to create instances of the ::Greeter class
# by calling the ::create class method.
class GreeterFactory

  @@greetings = JSON.parse(File.read('./models/greetings.json'))

  # Get all the language names that are available for creating
  # greeter objects.
  #
  # Returns:: An array with the name of the languages.
  def self.available_languages
    @@greetings.keys
  end

  # Creates a new greeter object.
  #
  # Parameter::
  #   language:: The language for the greeter object
  #              that will be created.
  #
  # Returns:: The newly created greeter object, or
  #           +nil+ if +language+ is unknown.
  def self.create(language)
    Greeter.new(language, @@greetings[language])
  end

end
