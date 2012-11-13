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
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(current_cart)
    if @order.save
      current_cart.destroy
      cart = Cart.new
      session[:cart_id] = cart.id
      MainMailer.order_notifier(@order).deliver
      redirect_to root_path, notice: 'Thank you for your order.'
    else
      @cart = current_cart
      render action: "new"
    end
  end

end
