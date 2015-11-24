class UserController
  def self.register(username, password)
    user = Users.create(username: username, password: password, admin: false, total_score: 0)
  end

  def self.login(username, password)
    user = Users.find({username: username})[0]
    if user.nil? or user.password != password
      nil
    else
      user
    end
  end

  def self.results
    results = Users.all
    results.select{|u| u.admin != 't'}.sort_by{|u| u.total_score}.reverse
    results
  end
  
  def self.update_total_score(user_id, score)
    user = Users.find({id: user_id})[0]
    user.total_score += score
    user.save
  end
end
