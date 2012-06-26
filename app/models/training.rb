class Training < ActiveRecord::Base
  attr_accessible :user_category, :direction
  belongs_to :user_category
  belongs_to :user

  validates :direction, :presence => true
  validates :user, :presence => true

  validate :user_category_must_belong_to_user
  validates_uniqueness_of :user_category_id, :scope => :direction_id
  validates_presence_of :user_category

  def direction
    if self.direction_id == 0
      :direct
    elsif self.direction_id == 1
      :translation
    else
      nil
    end
  end

  def direction=(val)
    if val == :direct
      self.direction_id = 0
    elsif val == :translation
      self.direction_id = 1
    else
      self.direction_id = -1
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
