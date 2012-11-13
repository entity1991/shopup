class Product < ActiveRecord::Base
  attr_accessible :description, :price, :title, :photo, :category_id

  belongs_to :store
  belongs_to :category
  has_many :line_items
  has_many :orders, :through => :line_items

  before_destroy :has_line_items?

  validates :title, :presence => true, :length => { :maximum => 30 }
  validates :price, :presence => true, :numericality => {greater_than_or_equal_to: 0.01}

  has_attached_file :photo, :styles => { :small => "150x150>" },
                    :url  => "/assets/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/jpg']
  validates :category_id, :presence => true

  private

  # ensure that there are no line items referencing this product
  def has_line_items?
    if line_items.empty?
      true
    else
      errors.add(:base, 'Line Items present')
      false
    end
  end

end
