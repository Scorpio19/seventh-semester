class UserController
  def self.create_user(username, password)
    #create new user with params
  end

  def self.find_user(username, password)
    if (username == 'admin' && password == 'password')
      User.new(username, password, true)
    elsif (username == 'User 1' && password == 'password')
      User.new(username, password, false)
    else
      nil
    end
  end

  def self.get_results
    results = Array.new
    results << User.new("User 1", [2, 3, 1, 3, 4], false)
    results << User.new("User 2", [1, 0, 3, 2, 1], false)
    results << User.new("User 3", [10, 0, 2, 3, 0], false)
    results.sort do |a, b|
      total_a = a.scores.reduce(:+)
      total_b = b.scores.reduce(:+)
    end
  end
end
