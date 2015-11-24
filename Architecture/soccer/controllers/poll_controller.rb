class PollController
  def self.create(match_amount, matches)
    games = PollController.parse_matches(match_amount, matches)
    if games
      poll = Polls.create(status: :open, matches: games, results: "")
    else
      false
    end
  end

  def self.current
    poll = Polls.all.last
  end

  def self.close
    poll = PollController.current
    poll.status = :closed
    poll.save
    poll
  end

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

  def self.all
    Polls.all
  end

  def self.matches
    poll = PollController.current
    matches = []
    JSON.parse(poll.matches).each do |m|
      matches << m.split(',')
    end
    matches
  end

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
