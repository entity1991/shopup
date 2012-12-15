class Admin::AssetsController < Admin::ApplicationController

  def index
    @assets = @store.assets
    @images = @assets.images
    @stylesheets = @assets.stylesheets
    @javascripts = @assets.javascripts
    @editor_theme = session[:editor_theme] || "default"
    @editor_ln = session[:editor_ln] ?  session[:editor_ln] : true
    @editor_font_size = session[:editor_font_size] || "10"
  end

  def load_asset
    @asset = Asset.find params[:asset_id]
    if @asset.stylesheet? or @asset.javascript?
      @lines = ""
      file_name = "./public/assets/store_assets/" + @asset.id.to_s + "/original/" + @asset.file_file_name
      if File.exist? file_name
        file_lines = File.open(file_name).readlines
        file_lines.each do |line|
          @lines << line
        end
      else

      end
    else

    end
    render :json => {
        name: @asset.file_file_name,
        type: @asset.type,
        content: @lines
    }
  end

  def update
    @asset = Asset.find params[:id]
    if @asset.stylesheet? or @asset.javascript?
      file_name = "./public/assets/store_assets/" + @asset.id.to_s + "/original/" + @asset.file_file_name
      if File.exist? file_name
        File.open(file_name, 'w')do |file|
          file.write params[:asset][:file_content]
        end
      else

      end
    else

    end
    respond_to do |format|
      format.html {redirect_to admin_store_asset_path(@store, @asset), :notice => "Asset was successfully updated."}
      format.json { render :json => {}, :status => 200}
    end
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

  def destroy
    @asset = Asset.find(params[:id])
    if @asset.destroy
      redirect_to admin_store_assets_path, notice: 'Asset was successfully deleted.'
    else
      redirect_to admin_store_assets_path, notice: 'Something went wrong'
    end
  end

  def download
    @asset = Asset.find(params[:asset_id])
    if @asset.stylesheet? or @asset.javascript?
      @lines = ""
      file_name = "./public/assets/store_assets/" + @asset.id.to_s + "/original/" + @asset.file_file_name
      if File.exist? file_name
        file_lines = File.open(file_name).readlines
        file_lines.each do |line|
          @lines << line
        end
      else

      end
    else

    end
    send_data(@lines, disposition: "inline")
  end


end
