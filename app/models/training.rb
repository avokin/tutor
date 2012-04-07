class Training < ActiveRecord::Base
  attr_accessible :user_category, :direction
  belongs_to :user_category
  belongs_to :user

  validates :direction, :presence => true
  validates :user, :presence => true

  validate :user_category_must_belong_to_user

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

  private
  def user_category_must_belong_to_user
    unless self.user_category.nil?
      if self.user_category.user != self.user
        errors.add(:user_category, "must belongs to current user")
      end
    end
  end
end
