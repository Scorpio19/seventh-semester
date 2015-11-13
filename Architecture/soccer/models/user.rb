class User
  attr_reader :name, :scores, :admin

  def initialize(name, scores, admin)
    @name = name
    @scores = scores
    @admin = admin
  end
end
