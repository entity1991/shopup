class Category < ActiveRecord::Base
  attr_accessible :name, :fields

  belongs_to :store
  has_many :products
  has_and_belongs_to_many :fields

  validates :name, :presence => true

end
