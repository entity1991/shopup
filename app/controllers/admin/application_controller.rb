class Admin::ApplicationController < ApplicationController

  before_filter :authenticate
  before_filter :owner?

  private

  def owner?
    store = (params[:store_id] ? Store.find(params[:store_id]) : Store.find(params[:id]))
    redirect_to root_path if store.owner != current_user
  end

end
