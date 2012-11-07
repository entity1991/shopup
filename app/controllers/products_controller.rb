class ProductsController < ApplicationController

  before_filter :current_store

  def index
    @products = @store.products
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = @store.products.build(params[:product])
    if @product.save
       redirect_to store_products_path, notice: 'Product was successfully created.'
    else
       render action: "new"
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to store_products_path, notice: 'Product was successfully created.'
    else
      render action: "new"
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to store_products_url
  end

  private

  def current_store
    @store = Store.find(params[:store_id])
  end

end
