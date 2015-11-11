# Activity: The Greeter App
# Date: 26-Nov-2015
# Author: Ariel Ortiz

# The +Greeter+ class represents an object that knows how
# to greet with a message in a certain language.
class Greeter

  # This greeter's language.
  attr_reader :language
  
  # This greeter's message.
  attr_reader :message

  # Creates a new +Greeter+ instance. Don't call this
  # method directly; instead, use the GreeterFactory::create
  # factory method.
  #
  # Parameters::
  #   language:: The language of the message for this
  #              greeter.
  #   message:: The message for this greeter.
  def initialize(language, message)
    @language = language
    @message = message
  end

  # Get a string containing the representation for this
  # greeter object.
  #
  # Returns:: This greeter's message as a string.
  def to_s
    @message.to_s
  end

end
