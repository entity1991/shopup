class Asset < ActiveRecord::Base
  ACCEPTED_CONTENT_TYPES = %w(image/jpeg image/png image/jpg text/css application/javascript)

  attr_accessor :file_content, :name, :ext
  attr_accessible :file, :active

  belongs_to :store

  Paperclip.interpolates :store do |attachment, style| attachment.instance.store.domain end
  Paperclip.interpolates :type do |attachment, style|
    attachment.instance.type ? "#{attachment.instance.type}s" : "temp"
  end
  has_attached_file :file, :url  => "/assets/stores/:store/:basename.:extension",
                           :path => ":rails_root/public/assets/stores/:store/:type/:basename.:extension"

  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 5.megabytes
  validates_attachment_content_type :file, :content_type => ACCEPTED_CONTENT_TYPES

  scope :images, where( :file_content_type => %w(image/jpeg image/png image/jpg))
  scope :stylesheets, where( :file_content_type => %w(text/css))
  scope :javascripts, where( :file_content_type => %w(application/javascript))
  scope :active, where( :active => 1)

  def image?
    self.file_content_type == "image/jpeg" ||
    self.file_content_type == "image/png" ||
    self.file_content_type == "image/jpg"
  end

  def stylesheet?
    self.file_content_type == 'text/css'
  end

  def javascript?
    self.file_content_type == 'application/javascript'
  end

  def type
    if image?
      "image"
      else if stylesheet?
        "stylesheet"
        else if javascript?
          "javascript"
        end
      end
    end
  end

  def path
    "./public/assets/stores/" + store.domain + "/" + type + "s/"
  end

  private

end
