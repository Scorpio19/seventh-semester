class UserController
  def self.register(username, password)
    user = User.create(username: username, password: password, admin: false, total_score: 0)
  end

  def self.login(username, password)
    user = User.find_by_username(username)
    if user.nil? or user.password != password
      nil
    else
      user
    end
  end

  def self.results
    results = User.all

    results.select {|u| !u.admin}.sort_by{|u| u.total_score}.reverse
  end
  
  def self.update_total_score(user_id, score)
    user = User.find(user_id)
    User.update(user_id, total_score: user.total_score + score)
  end
end
