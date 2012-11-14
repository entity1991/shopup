class FieldContent < ActiveRecord::Base
  attr_accessible :content, :field_id, :product_id
  belongs_to :product
  belongs_to :field
end
