class StoresController < ApplicationController

  before_filter :authenticate

  def index
    @stores = Store.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stores }
    end
  end

  def show
    @store = Store.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
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
    @store = Store.new(params[:store])
    @store.owner = current_user
    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @store = Store.find(params[:id])

    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @store = Store.find(params[:id])
    @store.destroy

    respond_to do |format|
      format.html { redirect_to stores_url }
    end
  end
end
