class Stores::ApplicationController < ApplicationController

  before_filter :get_current_store, :stylesheets, :javascripts
  before_filter :is_open?

  layout "stores/admin_wrapper"

  private

  def get_current_store
    @store ||= Store.find(params[:store_id])
  end

  def stylesheets
    @stylesheets = @store.stylesheets.active
  end

  def javascripts
    @javascripts = @store.javascripts.active
  end

  def is_open?
    if !@store.open? and @store.owner != current_user
      flash[:error] = "Store is closed in this moment"
      redirect_to root_path
    end
  end

end
