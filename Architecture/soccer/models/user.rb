class Users < InActiveRecord
  attr_accessor :admin, :password, :username, :total_score
  attr_reader :id, :created_at, :updated_at

  has_many :picks

  def initialize(params)
    @username = params[:username]
    @password = params[:password]
    @admin = params[:admin]
    @total_score = params[:total_score] || 0
    @id = params[:id]
    @created_at = params[:created_at]
    @updated_at = params[:updated_at]
  end

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
