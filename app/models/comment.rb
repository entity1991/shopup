class Comment < ActiveRecord::Base
  attr_accessible :content, :product_id, :deleted

  belongs_to :user
  belongs_to :product
end
