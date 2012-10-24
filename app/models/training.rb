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

  def get_ready_user_words(page)
    user_words = get_user_words(page)
    result = Array.new
    now = DateTime.now
    (0..user_words.length - 1).each do |i|
      result << user_words[i] if user_words[i].time_to_check <= now
    end
    result
  end

  def get_user_words(page)
    user_words = Array.new
    relations = WordRelation.find_all_by_user_id_relation_type_status_id(self.user, 1, 1, self.user_category)
    unless page.nil?
      relations = relations.paginate(:page => page, :per_page => self.user.word_per_page)
    end

    relations.each do |r|
      if self.direction == :direct
        user_words << r.source_user_word
      else
        user_words << r.related_user_word
      end
    end

    user_words
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
