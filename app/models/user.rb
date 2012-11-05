class User < ActiveRecord::Base
  attr_accessor :password #only virtual attribute(getter and setter)
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation  #editable attribute

  has_many :stores, :foreign_key => "owner_id"

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name,  :presence => true,
            :length           => { :maximum => 50 }
  validates :last_name,  :presence => true,
            :length           => { :maximum => 50 }
  validates :email, :presence => true,
            :format           => { :with => email_regex },
            :uniqueness       => true
  validates :password, :presence     => true,
            :confirmation => true,
            :length       => { :within => 6..40 }

  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def full_name
    self.first_name + " " + self.last_name
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def encrypt(pass)
    secure_hash("#{salt}--#{pass}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(pass)         []
  Digest::SHA2.hexdigest(pass)
  end

end
