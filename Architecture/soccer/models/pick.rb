# Final Project: Soccer Polls
# Date: 23-Nov-2015
# Authors:
#   A01370815   Diego Galindez Barreda
#   A01169999   Rodrigo Villalobos Sanchez
#   A01165957   Saul de Nova Caballero

# The +Picks+ class represents an object that knows which
# results a user expected for a certain pick
class Picks < InActiveRecord

  # The reference to the user that made this pick
  attr_accessor :user_id

  # The reference to the poll to which this pick belongs
  attr_accessor :poll_id

  # The score for this pick
  attr_accessor :score

  # The set of expected results for this pick
  attr_accessor :expected

  # This picks unique id. Obtained from the DB.
  attr_reader :id

  # Timestamps for this pick
  attr_reader :created_at, :updated_at

  belongs_to :users, "user_id"
  has_one :polls, "poll_id"

  # Creates a new +Picks+ instance. This method is called through
  # the InActiveRecord::create method and should not be called directly.
  #
  # Parameters::
  #   params:: A hash containing the necessary information to create a pick.
  #            It needs to contain at the very least the user_id, poll_id and
  #            expected results (as an array).
  def initialize(params)
    @user_id = params[:user_id]
    @poll_id = params[:poll_id]
    @score = params[:score]
    @expected = params[:expected]
    @id = params[:id]
    @created_at = params[:created_at]
    @updated_at = params[:updated_at]
  end

  # Creates as many new +Picks+ instances from the results array passed to it
  # by InActiveRecord::find or InActiveRecord::all. This method should not be 
  # called directly. It translates the array received to the required hash,
  # therefore it is dependent on the database following the adequate structure.
  #
  # Parameters::
  #   results:: An Array containing the rows (also represented as an array)
  #             returned from InActiveRecord::find or InActiveRecord::all.
  #             The table needs to have the adequate structure.
  #
  # Returns:: An array containing the +Picks+ from the result set
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
