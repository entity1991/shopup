class Admin::StoresController < Admin::ApplicationController

  before_filter :authenticate
  before_filter :boss?, :only => [:index]
  skip_before_filter :owner?, :only => [:new, :create, :index]

  def index
    @stores = Store.all
  end

  def show
    @store = Store.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end


  def statistic
    @store = Store.find(params[:store_id])
  end

  def new
    @store = Store.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @store = Store.find(params[:id])
  end

  def create
    @store = current_user.stores.build(params[:store])
    respond_to do |format|
      if @store.save
        format.html { redirect_to admin_store_path(@store), notice: 'Store was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @store = Store.find(params[:id])

    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to admin_store_path(@store), notice: 'Store was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @store = Store.find(params[:id])
    @store.destroy

    respond_to do |format|
      format.html { redirect_to admin_stores_path }
    end
  end

end
