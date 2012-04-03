class Training < ActiveRecord::Base
  attr_accessible :user_category, :direction
  belongs_to :user_category
  validates :direction, :presence => true

  def direction
    self.direction_id == 0 ? :direct : :translation
  end

  def direction=(val)
    if val == :direct
      self.direction_id = 0
    else
      self.direction_id = 1
    end
  end
end
