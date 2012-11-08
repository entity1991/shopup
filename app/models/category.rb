class Category < ActiveRecord::Base
  attr_accessible :name

  belongs_to :store
  has_many :products

end
