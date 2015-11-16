class UserController
  def self.create_user(username, password)
    User.create(username: username, password: password, admin: false)
  end

  def self.find_user(username, password)
    User.find(username, password)
  end

  def self.get_results
    results = User.all
    results.sort do |a, b|
      a.total_score
      b.total_score
    end
    results
  end
end
