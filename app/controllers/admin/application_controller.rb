class Admin::ApplicationController < ApplicationController

  before_filter :authenticate
  before_filter :get_current_store
  before_filter :owner?

  private

  def get_current_store
    @store = Store.find(params[:store_id] || params[:id])
  end

  def owner?
    redirect_to root_path if @store.owner != current_user
  end

end
