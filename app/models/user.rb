require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password

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
            :length       => { :within => 6..40 },
            :if           => :password

  validates :language, :presence => true
  validates :target_language, :presence => true

  before_save :encrypt_password

  before_create { generate_token(:auth_token) }

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    email = UserMailer.password_reset(self)
    email.deliver_now
    email
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def target_language_id=(val)
    self.target_language = Language.find(val)
  end

  def native_language_id=(val)
    self.language = Language.find(val)
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate_with_token(token)
    User.find_by_encrypted_password(token)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def foreign_user_words
    UserWord.where('user_id = ?', self.id).where('language_id = ?', self.target_language.id)
  end

  def native_user_words
    UserWord.where('user_id = ?', self.id).where('language_id = ?', self.language.id)
  end

  def word_per_page
    20
  end

  def update_password(password, password_confirmation)
    result = false
    User.transaction do
      self.password = password
      self.password_confirmation = password_confirmation
      if self.valid?
        self.password_reset_token = nil
        if !self.save
          raise ActiveRecord::Rollback
        else
          result = true
        end
      end
    end
    result
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
