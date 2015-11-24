# Final Project: Soccer Polls
# Date: 23-Nov-2015
# Authors:
#   A01370815   Diego Galindez Barreda
#   A01169999   Rodrigo Villalobos Sanchez
#   A01165957   Saul de Nova Caballero

# The +Polls+ class represents an object that contains
# the match information for a certain Soccer Poll. It
# also contains the results for it once it is concluded.
# Only one poll may be active at a time.
class Polls < InActiveRecord

  # The poll's current status, can be opened, closed 
  # or concluded.
  attr_accessor :status

  # The matches this poll refers to.
  attr_accessor :matches

  # The actual results of the matches this poll refers
  # to. This is filled once the poll is concluded.
  attr_accessor :results

  # This poll's unique id. Obtained from the DB.
  attr_reader :id
  
  # Timestamps for this poll.
  attr_reader :created_at, :updated_at

  has_many :picks

  # Creates a new +Polls+ instance. This method is called through
  # the InActiveRecord::create method and should not be called directly.
  #
  # Parameters::
  #   params:: A hash containing the necessary information to create a poll.
  #            It needs to contain at the very least the status and matches
  #            (as an array).
  def initialize(params)
    @status = params[:status]
    @matches = params[:matches]
    @results = params[:results]
    @id = params[:id]
    @created_at = params[:created_at]
    @updated_at = params[:updated_at]
  end

  # Creates as many new +Polls+ instances from the results array passed to it
  # by InActiveRecord::find or InActiveRecord::all. This method should not be 
  # called directly. It translates the array received to the required hash,
  # therefore it is dependent on the database following the adequate structure.
  #
  # Parameters::
  #   results:: An Array containing the rows (also represented as an array)
  #             returned from InActiveRecord::find or InActiveRecord::all.
  #             The table needs to have the adequate structure.
  #
  # Returns:: An array containing the +Polls+ from the result set
  def self.create_from_results(results)
    polls = Array.new
    results.each do |row|
      params = {}
      params[:id] = row[0]
      params[:status] = row[1]
      params[:matches] = row[2]
      params[:results] = row[3]
      params[:created_at] = row[4]
      params[:updated_at] = row[5]
      polls << self.new(params)
    end
    polls
  end
end
