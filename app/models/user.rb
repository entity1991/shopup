class User < ActiveRecord::Base
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :password #only virtual attribute(getter and setter)
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :avatar  #editable attribute

  has_many :stores, :foreign_key => "owner_id", :dependent => :destroy
  has_one :cart, :dependent => :destroy
  has_many :comments
  has_many :questions
  has_one :join_confirmation

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
                             :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"

  validates :first_name, :presence => true, :length => { :within => 3..20 }
  validates :last_name,  :presence => true, :length => { :within => 3..20 }
  validates :email,      :presence => true, :format => { :with => EMAIL_REGEX }, :uniqueness   => true
  validates :password,   :presence => true, :length => { :within => 6..40 },     :confirmation => true

  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/png image/jpg)

  before_save :encrypt_password
  after_create :send_registration_email

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    if user
      if user.join_confirmation == nil && user.has_password?(submitted_password)
        return user
        end
    end
    return nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def full_name
    self.first_name + " " + self.last_name
  end

  def send_registration_email
    self.join_confirmation = JoinConfirmation.create(:activation_code => Array.new(45){(97 + rand(26)).chr}.join)
    MainMailer.registration_email(self).deliver
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
