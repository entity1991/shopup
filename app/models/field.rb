class Field < ActiveRecord::Base
  attr_accessible :title, :content_type, :categories
  has_and_belongs_to_many :categories

  validates :title, :presence => true,
            :uniqueness => true
  validates :content_type, :presence => true
end
