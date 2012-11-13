class CartsController < ApplicationController

  def index
    @cart = current_cart
  end

  def show
    begin
      @cart = Cart.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to root_path, notice: 'Invalid cart'
    end
  end

  def destroy
    current_cart.destroy
    redirect_to root_path, notice: 'Your cart is currently empty'
  end

end
