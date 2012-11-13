class Stores::StoresController < Stores::ApplicationController

  def catalog
    @products = @store.products
  end

end
