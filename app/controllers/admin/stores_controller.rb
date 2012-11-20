class Admin::StoresController < Admin::ApplicationController

  before_filter :authenticate
  skip_before_filter :owner?, :only => [:new, :create]
  skip_before_filter :current_store, :except => [:orders, :statistic]

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
    @store = current_user.stores.build(params[:store])
    if @store.save
      redirect_to admin_store_path(@store), notice: 'Store was successfully created.'
    else
      render "new"
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
    @store = Store.find(params[:id]).destroy
    redirect_to root_path
  end

end
