class PickController
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

  def self.update_score(pick_id, score)
    pick = Picks.find({id: pick_id})[0]
    pick.score = score
    pick.save
    user_id = pick.users.id
    UserController.update_total_score(user_id, score)
  end
end
