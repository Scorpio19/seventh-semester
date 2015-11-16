class User < ActiveRecord::Base
end
=begin
  attr_reader :name, :admin, :picks

  def initialize(name, password, admin)
    @name = name
    @password = password
    @picks = Pick.find(name)
    @admin = admin
  end

  def total_score
    sum = 0
    @picks.each do |p|
      sum += p.score
    end
    sum
  end

  def self.all
    results = Array.new
    results << User.new("User1", "", false)
    results << User.new("User2", "", false)
    results << User.new("User3", "", false)
    results
  end

  def self.find(username, password)
    if username == 'admin' && password == 'password'
      User.new("admin", "password", [], true)
    elsif username == 'User1' && password == 'password'
      User.new("User1", "password", [], true)
    else
      nil
    end
  end
end
=end
