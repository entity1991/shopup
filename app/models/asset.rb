class Asset < ActiveRecord::Base
  ACCEPTED_CONTENT_TYPES = %w(image/jpeg image/png image/jpg text/css application/javascript)

  attr_accessor :file_content, :name, :type
  attr_accessible :file

  belongs_to :store

  has_attached_file :file,
                    :styles => lambda { |a| !(a.content_type =~ %r(image)).nil? ? {:small => "50x50>"} : {}},
                    :url  => "/assets/store_assets/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/store_assets/:id/:style/:basename.:extension"

  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 5.megabytes
  validates_attachment_content_type :file, :content_type => ACCEPTED_CONTENT_TYPES

  scope :images, where( :file_content_type => %w(image/jpeg image/png image/jpg))
  scope :stylesheets, where( :file_content_type => %w(text/css))
  scope :javascripts, where( :file_content_type => %w(application/javascript))

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
        "css"
        else if javascript?
          "javascript"
        end
      end
    end
  end

  private

end
