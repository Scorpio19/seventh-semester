# Final Project: Soccer Polls
# Date: 23-Nov-2015
# Authors:
#   A01370815   Diego Galindez Barreda
#   A01169999   Rodrigo Villalobos Sanchez
#   A01165957   Saul de Nova Caballero

# The +PickController+ class handles the communication
# between the model +Picks+ and the different views in
# which it has influence.
class PickController

  # Creates a new +Picks+ instance from the information passed to it, or
  # updates the information it contains in case it already exists.
  #
  # Parameters::
  #   user_id:: The identifier for the user that made this pick.
  #   poll_id:: The identifier for the poll this pick refers to.
  #   amount:: The amount of matches in this poll. Required for 
  #            proper parsing of the view's information.
  #   selected:: A hash containing the values for the matches the
  #              user selected for the current poll.
  #
  # Returns:: The generated +Picks+ instance or the updated one.
  def self.create(user_id, poll_id, amount, selected)
    expected = []
    amount.times do |i|
      e = selected["match_#{i}"]
      expected << e
    end
    pick = Picks.find({user_id: user_id, poll_id: poll_id})[0]
    if pick.nil? or pick.expected.nil?
      Picks.create(user_id: user_id, poll_id: poll_id, score: 0, expected: expected)
    else
      pick.expected = expected
      pick.save
      pick
    end
  end

  # Updates the score for the given pick, with the amount specified.
  # This is called through +PollController+ whenever a poll is concluded.
  # It also updates the pick's owner (user) score.
  #
  # Parameters::
  #   pick_id:: The identifier for the pick that must be updated.
  #   score:: The score that must be assigned th the pick.
  def self.update_score(pick_id, score)
    pick = Picks.find({id: pick_id})[0]
    pick.score = score
    pick.save
    user_id = pick.users.id
    UserController.update_total_score(user_id, score)
  end
end
