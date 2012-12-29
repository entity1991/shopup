class Product < ActiveRecord::Base
  attr_accessible :description, :price, :title, :photo, :category_id

  belongs_to :store
  belongs_to :category
  has_many :line_items
  has_many :orders, :through => :line_items
  has_many :field_contents
  has_many :comments, :dependent => :destroy

  before_destroy :has_line_items?

  validates :title, :presence => true, :length => { :maximum => 30 }
  validates :price, :presence => true, :numericality => {greater_than_or_equal_to: 0.01}

  Paperclip.interpolates :store do |attachment, style| attachment.instance.store.domain end
  has_attached_file :photo, :url  => "/assets/stores/products/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/assets/stores/:store/products/:id/:basename.:extension"

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/jpg']

  def save_with_fields fields
    if self.save
      if fields
        fields.each do |field_id, val|
          field = Field.find(field_id)
          if self.category.fields.include? field
            content_field = FieldContent.new
            content_field.content = val
            content_field.product = self
            content_field.field = field
            content_field.save
          end
        end
      end
      true
    else
      false
    end
  end
  # ensure that there are no line items referencing this product

  def self.search(params, page = 1, items_per_page)
    conditions = [""]
    if params[:q] && !params[:q].blank?
      conditions[0] = 'title like ? or description like ?'
      conditions << "%#{params[:q]}%"
      conditions << "%#{params[:q]}%"
    end
    if params[:category_id] && !params[:category_id].blank?
      if !conditions[0].blank?
        conditions[0] += " and "
      end
      conditions[0] += " category_id like ?"
      conditions << "%#{params[:category_id]}%"
    end

    paginate :per_page => items_per_page, :page => page,
             :conditions => conditions,
             :order => 'title'
  end

  private

  def has_line_items?
    if line_items.empty?
      true
    else
      errors.add(:base, 'Line Items present')
      false
    end
  end

end
