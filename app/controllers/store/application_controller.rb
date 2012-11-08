class Store::ApplicationController < ApplicationController

  layout "store/application"

  before_filter :current_store

  private

  def current_store
    @store = Store.find(params[:store_id])
  end

end
