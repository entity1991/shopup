class Admin::ProductsController < Admin::ApplicationController

  before_filter :store_categories, :only => [:new, :edit, :create, :update, :index]

  def index
    @products_data = []
    @categories.each do |cat|
      category = {}
      category[:title] = cat.name
      category[:products] = []
      cat.products.each do |prod|
        product = {}
        product[:base_product] = prod
        product[:fields] = []
        prod.field_contents.each do |f|
          field = {}
          field_model = f.field
          field[:title] = field_model.title
          field[:content] = f.content
          product[:fields] << field
        end

        category[:products] << product
      end
      @products_data << category
    end
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
    if @product.save_with_fields params[:fields]
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
    category = Category.find(params[:category_id])
    product = nil
    if Product.exists?(params[:product_id])
      product = Product.find(params[:product_id])
    end

    contains = {}
    if product
      product.field_contents.each do |content|
        contains[content.field_id] = content.content
      end
    end

    fields = []
    category.fields.each do |f|
      field = {}
      field[:model] = f
      field[:content] = contains[f.id] || ""
      fields << field
    end

    render :partial => 'dynamic_fields_for_category', :locals => { :fields => fields}
  end

  private

  def store_categories
    @categories = @store.categories
  end

end
