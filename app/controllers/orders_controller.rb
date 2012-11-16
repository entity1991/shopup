class OrdersController < ApplicationController

  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to root_path, notice: "Your cart is empty"
      return
    end
    @order = Order.new
  end

  def create
    if params[:store]
      unless create_order(Store.find params[:store])
        @store = Store.find params[:store]
        redirect_to stores_store_order_path(@store) and return
      end
    else
      stores = []
      current_cart.products.each do |product|
        stores << product.store unless stores.include? product.store
      end unless current_cart.empty?
      stores.each do |store|
         render "new" and return unless create_order(store)
      end unless stores.empty?
    end
    redirect_to root_path, notice: 'Thank you for your order.'
  end

  private

  def create_order(store)
    successfully = true
    cart = Cart.new
    current_cart.line_items.each do |ln|
      if ln.product.store == store
        cart.line_items << ln
      end
    end
    @order = store.orders.build(params[:order])
    @order.add_line_items_from_cart(cart)
    if @order.save
      current_cart.line_items.each do |ln|
        ln.destroy if ln.product.store == store
      end
      MainMailer.order_notifier(@order, store).deliver
    else
      successfully = false
    end
    successfully
  end

end
