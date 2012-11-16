class Stores::StoresController < Stores::ApplicationController

  def catalog
    @products = @store.products
  end

  def cart
    @cart = Cart.new
    current_cart.line_items.each do |ln|
      if ln.product.store == @store
        @cart.line_items << ln
      end
    end
  end

  def order
    @order = Order.new
  end

  def product_detail
    @product = Product.find(params[:product_id])
  end

end
