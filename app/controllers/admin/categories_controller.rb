class Admin::CategoriesController < Admin::ApplicationController

  def index
    @categories = @store.categories
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = @store.categories.build(params[:category])
    if @category.save
      redirect_to admin_store_categories_path, notice: 'Product was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to admin_store_categories_path, notice: 'Product was successfully updated.'
    else
      render action: "new"
    end
  end

  def destroy
    @category = Category.find(params[:id]).destroy
    redirect_to admin_store_categories_path
  end

end
