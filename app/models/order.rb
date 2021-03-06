class Order < ActiveRecord::Base
  attr_accessible :address, :email, :name, :pay_type

  has_many :line_items, :dependent => :destroy
  has_many :products, :through => :line_items
  belongs_to :store

  validates :name, :address, :email, presence: true

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      self.line_items << item
    end
  end

  def total_price
    self.line_items.to_a.sum {|item| item.total_price}
  end
end
