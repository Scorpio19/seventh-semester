class Poll < ActiveRecord::Base
  has_many :picks
end
