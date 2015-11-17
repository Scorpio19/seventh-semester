class PickController
  def self.create(user_id, poll_id, amount, selected)
    expected = []
    amount.times do |i|
      e = selected["match_#{i}"]
      expected << e
    end
    pick = Pick.find_by_user_id_and_poll_id(user_id, poll_id)
    if pick.nil? or pick.expected.nil?
      Pick.create(user_id: user_id, poll_id: poll_id, score: 0, expected: expected)
    else
      Pick.update(pick.id, expected: expected)
    end
  end

  def self.update_score(pick_id, score)
    Pick.update(pick_id, score: score)
    user_id = Pick.find(pick_id).user.id
    UserController.update_total_score(user_id, score)
  end
end
