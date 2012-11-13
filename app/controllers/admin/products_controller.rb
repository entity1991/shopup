class Admin::ProductsController < Admin::ApplicationController

  before_filter :store_categories, :only => [:new, :edit, :create, :update]

  def index
    @categories = @store.categories   #нащо воно тут, якшо прописано в before filter
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

  def dynamic_fields_for_category
    @fields = Category.find(params[:category_id]).fields
    render :partial => 'dynamic_fields_for_category', :locals => { :fields => @fields }
  end

  private

  def store_categories
    @categories = @store.categories
  end

end
