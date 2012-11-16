class CartsController < ApplicationController

  def index
    @cart = current_cart
    @carts = []
    stores = []
    current_cart.products.each do |product|
      stores << product.store unless stores.include? product.store
    end unless current_cart.empty?
    stores.each do |store|
      cart = Cart.new
      current_cart.line_items.each do |ln|
        if ln.product.store == store
          cart.line_items << ln
        end
      end
      cart.store = store
      @carts << cart
    end unless stores.empty?
  end

  def show
    begin
      @cart = Cart.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to root_path, notice: 'Invalid cart'
    end
  end

  def empty_cart_from_store
    current_cart.line_items.each do |ln|
      ln.destroy if ln.product.store.id.to_s == params[:store_id]
    end
    redirect_to :back
  end

  def destroy
    current_cart.destroy
    redirect_to root_path, notice: 'Your cart is currently empty'
  end

end
