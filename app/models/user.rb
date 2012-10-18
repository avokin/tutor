require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :target_language_id, :success_count, :native_language_id

  has_many :user_categories

  has_many :user_words
  belongs_to :language, :foreign_key => :native_language_id
  belongs_to :target_language, :class_name => "Language", :foreign_key => :target_language_id

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :presence => true,
            :confirmation => true,
            :length       => { :within => 6..40 }, :on => :create

  before_save :encrypt_password

  before_create { generate_token(:auth_token) }

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def target_language_id=(val)
    self.target_language = Language.find(val)
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = User.find_by_email(email)
    unless user.nil?
      return user.has_password?(submitted_password) ? user : nil
    end
    nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def foreign_user_words
    UserWord.joins(:word).where('user_id = ?', self.id).where('words.language_id = ?', self.target_language.id)
  end

  def word_per_page
    20
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
