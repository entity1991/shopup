class Field < ActiveRecord::Base
  attr_accessible :title, :content_type, :name, :categories
  has_and_belongs_to_many :categories

  validates :title, :presence => true,
            :uniqueness => true
  validates :content_type, :presence => true

  def self.types
    return ['string', 'integer', 'price', 'color']
  end
end
