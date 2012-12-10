class Store < ActiveRecord::Base

  require "RMagick"

  attr_accessible :domain, :name, :capture

  CAPTURE_PATH = './app/assets/images/'
  CAPTURE_W = 165
  CAPTURE_H = 150

  belongs_to :owner,    :class_name => "User"
  has_many :products,   :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :orders,     :dependent => :destroy
  has_many :assets,     :dependent => :destroy

  validates :name,   :presence => true, :length => { :maximum => 15 }
  validates :domain, :presence => true, :length => { :maximum => 15 }, :uniqueness => true

  scope :opened, where( :open => 1)
  scope :closed, where( :open => 0)

  def capture_full_path
    CAPTURE_PATH + self.capture
  end

  def take_capture
    path_to_saving_capture = CAPTURE_PATH + 'stores_captures/' + self.domain + '.png'
    begin
      profile = Selenium::WebDriver::Firefox::Profile.new
      driver = Selenium::WebDriver.for :firefox, :profile => profile
      driver.navigate.to "http://facebook.com/"
      driver.save_screenshot(path_to_saving_capture)
      driver.quit()
      large_snapshot = Magick::Image.read(path_to_saving_capture).first.resize_to_fill(CAPTURE_W, CAPTURE_H)
      small_snapshot = Magick::Image.new(CAPTURE_W, CAPTURE_H).composite!(large_snapshot, 0, 0, Magick::OverCompositeOp)
      small_snapshot.write(path_to_saving_capture)
      self.update_attribute :capture, 'stores_captures/' + self.domain + '.png'
    rescue
    end
  end

end
