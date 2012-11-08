class Store::CatalogsController < Store::ApplicationController

  def index
    @products = @store.products
  end

end
