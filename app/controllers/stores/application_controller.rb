class Stores::ApplicationController < ApplicationController

  before_filter :current_store, :stylesheets, :javascripts
  before_filter :is_open?

  layout "stores/application"

  private

  def current_store
    @store ||= Store.find(params[:store_id])
  end

  def stylesheets
    @stylesheets = current_store.stylesheets.active
  end

  def javascripts
    @javascripts = current_store.javascripts.active
  end

  def is_open?
    unless @store.open?
      flash[:error] = "Store is closed in this moment"
      redirect_to root_path
    end
  end

end
