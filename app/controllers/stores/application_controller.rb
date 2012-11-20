class Stores::ApplicationController < ApplicationController

  before_filter :current_store

  layout "stores/application"

  private

  def current_store
    @store = Store.find(params[:store_id])
  end


end
