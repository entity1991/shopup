class Field < ActiveRecord::Base
  attr_accessible :title, :content_type, :categories
  has_and_belongs_to_many :categories
  has_many :field_contents

  validates :title, :presence => true,
            :uniqueness => true
  validates :content_type, :presence => true

  def self.types
    return ['string', 'integer', 'price', 'color']
  end

  def save_with_categories categories
    if categories == nil
      self.valid?
      errors.add(:categories, "You must select some categories")
      return false
    end
    if self.save
      self.categories.each do |cat|
        if categories[cat.id] == nil
          self.categories.delete(cat)
        end
      end
      categories.each do |key, value|
        category = Category.find(key)
        if category && !category.fields.include?(self)
          category.fields << self
        end
      end
      true
    else
      false
    end
  end

end
