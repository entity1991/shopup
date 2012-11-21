class Admin::AssetsController < Admin::ApplicationController

  def index
    @assets = @store.assets
    @images = @assets.images
    @stylesheets = @assets.stylesheets
    @javascripts = @assets.javascripts
  end

  def new
    @asset = Asset.new
  end

  def create
    @asset = @store.assets.build(params[:asset])
    if @asset.save
      redirect_to admin_store_assets_path, notice: 'Asset was successfully created.'
    else
      render action: "new"
    end
  end

end
