class Store::PagesController < ApplicationController

  layout "store/application"

  def home
     @store = Store.find(params[:store_id])
  end
end
