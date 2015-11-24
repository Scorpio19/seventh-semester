# Final Project: Soccer Polls
# Date: 23-Nov-2015
# Authors:
#   A01370815   Diego Galindez Barreda
#   A01169999   Rodrigo Villalobos Sanchez
#   A01165957   Saul de Nova Caballero

# The +UserController+ class handles the communication
# between the model +Users+ and the different views in
# which it has influence.
class UserController

  # Creates a new +Users+ instance from the information passed to it.
  #
  # Parameters::
  #   username:: The user's unique name
  #   password:: The user's password
  #
  # Returns:: The created +Users+ instance
  def self.register(username, password)
    user = Users.create(username: username, password: password, admin: false, total_score: 0)
  end

  # Searches for a user with the provided values. If it is not found, 
  # it prevents login. If it is, it returns it.
  #
  # Parameters::
  #   username:: The user's given name
  #   password:: The user's password that should match with the name
  #
  # Returns:: The found +Users+ instance or nil if not found.
  def self.login(username, password)
    user = Users.find({username: username})[0]
    if user.nil? or user.password != password
      nil
    else
      user
    end
  end

  # Returns the set of results for all the users, sorted by score.
  # It contains the results for each poll.
  #
  # Returns:: A sorted array with the results for each user.
  def self.results
    results = Users.all
    results.select{|u| u.admin != 't'}.sort_by{|u| u.total_score}.reverse
    results
  end
  
  # Updates the total score for the indicated user. This method is
  # called through +PickController+ whenever a poll is concluded.
  #
  # Parameters::
  #   user_id:: The user's unique identifier in the Database.
  #   score:: The amount that should the added to the user's total
  #           score.
  #
  # Returns:: The updated user instance
  def self.update_total_score(user_id, score)
    user = Users.find({id: user_id})[0]
    user.total_score += score
    user.save
  end
end
