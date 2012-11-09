class StoresController < ApplicationController

  before_filter :current_store

  layout "store/application"

  def catalog
    @products = @store.products
  end

  private

  def current_store
    @store = Store.find(params[:store_id])
  end

end
