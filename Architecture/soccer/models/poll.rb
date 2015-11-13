class Poll 
  attr_reader :id
  attr_accessor :matches, :results, :status

  def initialize(matches)
    @matches = matches
    @results = Array.new
    @status = :open
  end
end
