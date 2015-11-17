class Pick < ActiveRecord::Base
  belongs_to :user
  has_one :poll
end
