class LineItemsController < ApplicationController

  def create
    product = Product.find(params[:product_id])
    @line_item = current_cart.add_product(product.id)
    if @line_item.save
      redirect_to carts_path
    else
      render action: "new"
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id]).destroy
    redirect_to root_path
  end

end
