# Final Project: Soccer Polls
# Date: 23-Nov-2015
# Authors:
#   A01370815   Diego Galindez Barreda
#   A01169999   Rodrigo Villalobos Sanchez
#   A01165957   Saul de Nova Caballero

# The +PollController+ class handles the communication
# between the model +Polls+ and the different views in
# which it has influence.
class PollController

  # Creates a new +Polls+ instance from the information passed to it.
  #
  # Parameters::
  #   match_amount:: The amount of matches in this poll.
  #   matches:: A hash containing the values for the matches.
  #
  # Returns:: The generated +Polls+ instance.
  def self.create(match_amount, matches)
    games = PollController.parse_matches(match_amount, matches)
    if games
      poll = Polls.create(status: :open, matches: games, results: "")
    else
      false
    end
  end

  # Gets the "latest" poll, which is always the last or currently 
  # active one.
  #
  # Returns:: The latest +Polls+ instance.
  def self.current
    poll = Polls.all.last
  end

  # Changes the current poll's status to closed, preventing users
  # from entering new picks.
  #
  # Returns:: The latest +Polls+ instance with the updated status.
  def self.close
    poll = PollController.current
    poll.status = :closed
    poll.save
    poll
  end

  # Changes the current poll's status to concluded, and calculates
  # the scores for each of the picks for all users. It also makes sure
  # each pick is adequately updated through the PickController::update_score
  # method.
  #
  # Parameters::
  #   games:: A hash containing the results for the matches.
  #
  # Returns:: The updated and concluded poll
  def self.conclude(games)
    poll = PollController.current
    picks = poll.picks
    results = []
    scores = Hash.new(0)
    JSON.parse(poll.matches).count.times do |i|
      r = games["match_#{i}"]
      picks.each do |p|
        if JSON.parse(p.expected)[i] == r
          scores[p.id] += 1;
        end
      end
      results << r
    end

    scores.each do |id, s|
      PickController.update_score(id, s)
    end

    poll.results = results
    poll.status = :concluded
    poll.save
    poll
  end

  # Returns all the +Polls+ contained in the DataBase, so the results can
  # be properly displayed.
  #
  # Returns:: An array containing all the +Polls+ instances.
  def self.all
    Polls.all
  end

  # Parses the current Poll's matches so they can be displayed where necessary.
  #
  # Returns:: An array containing the matches values.
  def self.matches
    poll = PollController.current
    matches = []
    JSON.parse(poll.matches).each do |m|
      matches << m.split(',')
    end
    matches
  end

  # Parses a set of matches from the view to an array, with the team names
  # separated by a comma and a match per array slot.
  #
  # Parameters::
  #   match_amount:: The number of matches.
  #   matches:: A hash containing the matches values.
  #
  # Returns:: The parsed matches as an array.
  def self.parse_matches(match_amount, matches)
    parsed = []
    match_amount.times do |i|
      a = matches["a_#{i}"]
      b = matches["b_#{i}"]
      if a.nil? or a.empty? or b.nil? or b.empty?
        parsed = nil
        break
      end
      match = a + "," + b
      parsed << match
    end
    parsed
  end
end
