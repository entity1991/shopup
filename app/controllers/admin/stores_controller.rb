class Admin::StoresController < Admin::ApplicationController

  before_filter :authenticate
  skip_before_filter :owner?, :only => [:new, :create]
  skip_before_filter :get_current_store, :only => [:new, :create]

  def show
    @store = Store.find(params[:id])
  end

  def statistic

  end

  def orders
    @orders = Order.find_all_by_store_id @store, :order => "created_at desc"
  end

  def new
    @store = Store.new
  end

  def edit
    @store = Store.find(params[:id])
  end

  def create
    @store = current_user.stores.new(params[:store])
    if @store.save
      @store.create_default_assets
      @store.take_capture
      redirect_to admin_store_path(@store), notice: 'Store was successfully created.'
    else
      # todo refactoring to render
      redirect_to :back
    end
  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      redirect_to admin_store_path(@store), notice: 'Store was successfully updated.'
    else
      render action: "edit"
    end
  end

  def open
    @store = Store.find(params[:id])
    @store.update_attribute("open", 1)
    redirect_to :back
  end

  def close
    @store = Store.find(params[:id])
    @store.update_attribute("open", 0)
    redirect_to :back
  end

  def destroy
    @store = Store.find(params[:id])
    capture =  @store.capture_full_path
    if File.exist? capture
      File.delete capture
    end
    @store.destroy
    redirect_to root_path
  end

end
