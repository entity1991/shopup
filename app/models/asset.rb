class Asset < ActiveRecord::Base
  attr_accessor :file_content
  attr_accessible :file

  belongs_to :store

  has_attached_file :file,
                    :styles => lambda { |a| !(a.content_type =~ %r(image)).nil? ? {:small => "50x50>"} : {}},
                    :url  => "/assets/store_assets/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/store_assets/:id/:style/:basename.:extension"

  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 5.megabytes
  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/png', 'image/jpg', 'text/css', 'application/javascript']

  scope :images, where( :file_content_type => ['image/jpeg', 'image/png', 'image/jpg'])
  scope :stylesheets, where( :file_content_type => ['text/css'])
  scope :javascripts, where( :file_content_type => ['application/javascript'])

  def image?
    self.file_content_type == ['image/jpeg', 'image/png', 'image/jpg']
  end

  def stylesheet?
    self.file_content_type == 'text/css'
  end

  def javascript?
    self.file_content_type == 'application/javascript'
  end

  private

end
