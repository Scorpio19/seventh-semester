class Picks < InActiveRecord
  attr_accessor :user_id, :poll_id, :score, :expected
  attr_reader :id, :created_at, :updated_at

  belongs_to :users, "user_id"
  has_one :polls, "poll_id"

  def initialize(params)
    @user_id = params[:user_id]
    @poll_id = params[:poll_id]
    @score = params[:score]
    @expected = params[:expected]
    @id = params[:id]
    @created_at = params[:created_at]
    @updated_at = params[:updated_at]
  end

  def self.create_from_results(results)
    polls = Array.new
    results.each do |row|
      params = {}
      params[:id] = row[0]
      params[:user_id] = row[1]
      params[:poll_id] = row[2]
      params[:score] = row[3]
      params[:expected] = row[4]
      params[:created_at] = row[5]
      params[:updated_at] = row[6]
      polls << self.new(params)
    end
    polls
  end
end
