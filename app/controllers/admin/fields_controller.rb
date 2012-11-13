class Admin::FieldsController < ApplicationController
  before_filter :current_store
  #before filter  якшо юзер мае права

  def index
    @categories = @store.categories
  end

  def show
  end

  def new
    @field = Field.new
  end

  def create
    @field = Field.new(params[:field])
    if @field.save
      params[:categories].each do |key, value|
        category = Category.find(key)
        if category
          category.fields << @field
        end
      end
      redirect_to admin_store_fields_path, notice: 'Field was successfully created.'
    else
      render "new"
    end
  end

  def edit
    @field = Field.find(params[:id])
  end

  def destroy
    @category = Category.find(params[:category_id])
    @field = Field.find(params[:id])
    if @category.fields.include?(@field)
      @category.fields.delete(@field)
    end
    redirect_to admin_store_fields_path, notice: 'Field was successfully deleted.'
  end

  def update
  end

  private

  def current_store
    @store = Store.find(params[:store_id])
  end
end
