class Admin::ProductsController < Admin::ApplicationController

  before_filter :current_store

  def index
    @products = @store.products
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
    @categories = @store.categories
  end

  def edit
    @product = Product.find(params[:id])
    @categories = @store.categories
  end

  def create
    @product = @store.products.build(params[:product])
    if @product.save
       redirect_to admin_store_products_path, notice: 'Product was successfully created.'
    else
       render action: "new"
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to admin_store_products_path, notice: 'Product was successfully updated.'
    else
      render action: "new"
    end
  end

  def destroy
    @product = Product.find(params[:id]).destroy
    redirect_to admin_store_products_path
  end

  private

  def current_store
    @store = Store.find(params[:store_id])
  end

end
