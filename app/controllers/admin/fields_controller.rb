class Admin::FieldsController < Admin::ApplicationController
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
    if @field.save_with_categories params[:categories]
      redirect_to admin_store_fields_path, notice: 'Field was successfully created.'
    else
      render :action => "new"
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
    @field = Field.find(params[:id])
    if @field.save_with_categories params[:categories]
      redirect_to admin_store_fields_path, notice: 'Field was successfully created.'
    else
      render "edit"
    end
  end

end
