class Comment < ActiveRecord::Base
  attr_accessible :content, :product_id

  belongs_to :user
  belongs_to :produduct
end
