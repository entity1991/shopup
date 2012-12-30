class Asset < ActiveRecord::Base
  ACCEPTED_CONTENT_TYPES = %w(image/jpeg image/png image/jpg text/css application/javascript text/html text/rhtml)

  attr_accessor :file_content, :name, :ext
  attr_accessible :file, :active

  belongs_to :store

  Paperclip.interpolates :store do |attachment, style| attachment.instance.store.domain end
  Paperclip.interpolates :type do |attachment, style|
    attachment.instance.type ? "#{attachment.instance.type}s" : "temp"
  end
  has_attached_file :file, :url  => "/assets/stores/:store/:type/:basename.:extension",
                           :path => ":rails_root/public/assets/stores/:store/:type/:basename.:extension"

  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 5.megabytes
  validates_attachment_content_type :file, :content_type => ACCEPTED_CONTENT_TYPES

  scope :images,      where( :file_content_type => %w(image/jpeg image/png image/jpg))
  scope :stylesheets, where( :file_content_type => %w(text/css))
  scope :javascripts, where( :file_content_type => %w(application/javascript))
  scope :htmls,       where( :file_content_type => %w(text/rhtml text/html))
  scope :active,      where( :active => 1)

  def image?
    file_content_type == "image/jpeg" ||
    file_content_type == "image/png" ||
    file_content_type == "image/jpg"
  end

  def stylesheet?
    file_content_type == 'text/css'
  end

  def javascript?
    file_content_type == 'application/javascript'
  end

  def html?
    file_content_type == 'text/rhtml' ||
    file_content_type == 'text/html'
  end

  def type
    if image?
      "image"
      else if stylesheet?
        "stylesheet"
        else if javascript?
          "javascript"
          else if html?
           "html"
          end
        end
      end
    end
  end

  def path
    "./public/assets/stores/" + store.domain + "/" + type + "s/"
  end

  private

end
