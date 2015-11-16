class Pick < ActiveRecord::Base
end
=begin
  attr_reader :id
  attr_accessor :poll_id, :user_id, :expected, :score

  def initialize(user_id, poll_id, expected)
    @user_id = user_id
    @poll_id = poll_id
    @expected = expected
    @score = 0
  end

  def self.find(name)
    results = Array.new
    if (name == "User 1")
      pick = Pick.new("User 1", "1", [])
      pick.score = 1
      results << pick
      pick = Pick.new("User 1", "1", [])
      pick.score = 2
      results << pick
      pick = Pick.new("User 1", "1", [])
      pick.score = 3
      results << pick
      pick = Pick.new("User 1", "1", [])
      pick.score = 4
      results << pick
    elsif (name == "User 2")
      pick = Pick.new("User 2", "1", [])
      pick.score = 2
      results << pick
      pick = Pick.new("User 2", "1", [])
      pick.score = 0
      results << pick
      pick = Pick.new("User 2", "1", [])
      pick.score = 10
      results << pick
      pick = Pick.new("User 2", "1", [])
      pick.score = 0
      results << pick
    else
      pick = Pick.new("User 3", "1", [])
      pick.score = 1
      results << pick
      pick = Pick.new("User 3", "1", [])
      pick.score = 0
      results << pick
      pick = Pick.new("User 3", "1", [])
      pick.score = 0
      results << pick
      pick = Pick.new("User 3", "1", [])
      pick.score = 5
      results << pick
    end
    results
  end
end
=end
