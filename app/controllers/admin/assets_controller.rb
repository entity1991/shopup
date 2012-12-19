class Admin::AssetsController < Admin::ApplicationController

  def index
    @assets = @store.assets
    @images = @assets.images
    @stylesheets = @assets.stylesheets
    @javascripts = @assets.javascripts
    @asset = Asset.new
    @editor_theme = session[:editor_theme] || "default"
    @editor_ln = session[:editor_ln] ?  session[:editor_ln] : true
    @editor_font_size = session[:editor_font_size] || "10"
  end

  def load_asset
    @asset = Asset.find params[:asset_id]
    if @asset.stylesheet? or @asset.javascript?
      @lines = ""
      file_name = path_to_asset @asset
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
      file_name = path_to_asset @asset
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

  def create
    @new_images = []
    @new_stylesheets = []
    @new_javascripts = []

    if params[:upload]
      if params[:asset]
        uploaded_asset = params[:asset]
        params[:asset][:file].each do |file|
          uploaded_asset[:file] = file
          @asset = @store.assets.build(uploaded_asset)
          if @asset.save
            if @asset.image?
              @new_images << @asset
            elsif @asset.stylesheet?
              @new_stylesheets << @asset
            elsif @asset.javascript?
              @new_javascripts << @asset
            end
          end
        end
      end
    elsif params[:create]
      name = params[:asset][:name]
      type = params[:asset][:type]
      full_file_name = name + "." + type
      @asset = @store.assets.new
      @asset.update_attribute(:file, File.new(TEMPORARY_EMPTY_FILE_PATH))
      old_file_path = path_to_asset @asset
      new_file_path = "./public/assets/store_assets/" + @asset.id.to_s + "/original/" + full_file_name
      File.rename(old_file_path, new_file_path)
      if type == "css"
        content_type = "text/css"
      elsif type == "js"
        content_type = "application/javascript"
      else
        content_type = "inode/x-empty"
      end
      @asset.update_attribute(:file_content_type, content_type)
      @asset.update_attribute(:file_file_name, full_file_name)
      if @asset.stylesheet?
        @new_stylesheets << @asset
      elsif @asset.javascript?
        @new_javascripts << @asset
      end
    end

    respond_to do |format|
      format.js
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

  private

  def path_to_asset(asset)
    "./public/assets/store_assets/" + asset.id.to_s + "/original/" + asset.file_file_name
  end

end
