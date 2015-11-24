class Polls < InActiveRecord
  attr_accessor :status, :matches, :results
  attr_reader :id, :created_at, :updated_at

  has_many :picks

  def initialize(params)
    @status = params[:status]
    @matches = params[:matches]
    @results = params[:results]
    @id = params[:id]
    @created_at = params[:created_at]
    @updated_at = params[:updated_at]
  end

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
