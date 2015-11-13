class Pick
  attr_reader :id
  attr_accessor :poll_id, :user_id, :expected, :score

  def initialize(user_id, poll_id, expected)
    @user_id = user_id
    @poll_id = poll_id
    @expected = expected
    @score = 0
  end
end
