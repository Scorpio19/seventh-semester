class Poll < ActiveRecord::Base
end
=begin
  attr_accessor :id, :matches, :results, :status

  def initialize(matches)
    @matches = matches
    @results = Array.new
    @status = :open
  end

  def self.find(id)
  end

  def self.all
  end

  def close_poll
    @status = :closed
  end

  def conclude_poll(results)
    @status = :concluded
    @results = results
  end
end
=end
