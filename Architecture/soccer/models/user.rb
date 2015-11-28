# Final Project: Soccer Polls
# Date: 23-Nov-2015
# Authors:
#   A01370815   Diego Galindez Barreda
#   A01169999   Rodrigo Villalobos Sanchez
#   A01165957   Saul de Nova Caballero

# The +Users+ class represents a user for the system.
# It contains the user's unique name and password for
# authentication. It also contains the user's total score
# which is updated whenever a poll is concluded.
class Users < InActiveRecord

  # The user's status as admin or normal user
  attr_accessor :admin

  # The user's password
  attr_accessor :password

  # The user's unique name
  attr_accessor :username

  # The user's total score through all polls
  attr_accessor :total_score

  # The user's unique identifier from the DB.
  attr_reader :id

  # Timestamps for this user.
  attr_reader :created_at, :updated_at

  has_many :picks

  # Creates a new +Users+ instance. This method is called through
  # the InActiveRecord::create method and should not be called directly.
  #
  # Parameters::
  #   params:: A hash containing the necessary information to create a poll.
  #            It needs to contain at the very least the username, password
  #            and whether the user is an admin or not.
  def initialize(params)
    @username = params[:username]
    @password = params[:password]
    @admin = params[:admin]
    @total_score = params[:total_score] || 0
    @id = params[:id]
    @created_at = params[:created_at]
    @updated_at = params[:updated_at]
  end

  # Creates as many new +Users+ instances from the results array passed to it
  # by InActiveRecord::find or InActiveRecord::all. This method should not be 
  # called directly. It translates the array received to the required hash,
  # therefore it is dependent on the database following the adequate structure.
  #
  # Parameters::
  #   results:: An Array containing the rows (also represented as an array)
  #             returned from InActiveRecord::find or InActiveRecord::all.
  #             The table needs to have the adequate structure.
  #
  # Returns:: An array containing the +Users+ from the result set
  def self.create_from_results(results)
    users = Array.new
    results.each do |row|
      params = {}
      params[:id] = row[0]
      params[:username] = row[1]
      params[:password] = row[2]
      params[:admin] = row[3]
      params[:total_score] = row[4]
      params[:created_at] = row[5]
      params[:updated_at] = row[6]
      users << self.new(params)
    end
    users
  end
end
