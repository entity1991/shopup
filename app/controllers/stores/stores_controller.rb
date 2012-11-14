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

  def empty_cart
    current_cart.line_items.each do |ln|
      ln.destroy if ln.product.store == @store
    end
    redirect_to :back
  end

end
