class LineItem < ActiveRecord::Base
  attr_accessible :cart_id, :product_id

  belongs_to :product
  belongs_to :cart
  belongs_to :order

  def total_price
    self.product.price * self.quantity
  end
end
