class Admin::AssetsController < Admin::ApplicationController

  def index
    @assets = @store.assets
    @images = @assets.images
    @stylesheets = @assets.stylesheets
    @javascripts = @assets.javascripts
    @htmls = @assets.htmls
    @asset = Asset.new
    @editor_theme = session[:editor_theme] || "default"
    @editor_ln = session[:editor_ln] ?  session[:editor_ln] : true
    @editor_font_size = session[:editor_font_size] || "10"
  end

  def load_asset
    @asset = Asset.find params[:asset_id]
    unless @asset.image?
      @lines = ""
      file_name = @asset.path + @asset.file_file_name
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
    unless @asset.image?
      file_name = @asset.path + @asset.file_file_name
      if File.exist? file_name
        File.open(file_name, 'w')do |file|
          file.write params[:asset][:file_content]
        end
        @asset.update_attribute(:file_file_size, File.new(@asset.path + @asset.file_file_name).size)
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
    @new_assets =[]
    @new_htmls = []

    if params[:upload]
      if params[:asset]
        uploaded_asset = params[:asset]
        params[:asset][:file].each do |file|
          uploaded_asset[:file] = file
          @asset = @store.assets.build(uploaded_asset)
          if @asset.save
            @new_assets << @asset
            if @asset.image?
              @new_images << @asset
            elsif @asset.stylesheet?
              @new_stylesheets << @asset
            elsif @asset.javascript?
              @new_javascripts << @asset
            elsif @asset.html?
              @new_htmls << @asset
            end
          end
        end
      end
    elsif params[:create]
      if params[:asset][:name] != ""
        name = params[:asset][:name]
        ext = params[:asset][:ext]
        full_file_name = name + "." + ext
        @asset = @store.assets.new
        @asset.update_attribute(:file, File.new(TEMPORARY_EMPTY_FILE_PATH))
        if ext == "css"
          content_type = "text/css"
        elsif ext == "js"
          content_type = "application/javascript"
        elsif ext == "html"
          content_type = "text/html"
        elsif ext == "erb"
          content_type = "text/rhtml"
        else
          content_type = "inode/x-empty"
        end
        @asset.update_attribute(:file_content_type, content_type)
        old_file_path = "./public/assets/stores/" + @asset.store.domain + "/temp/" + @asset.file_file_name
        new_file_path = @asset.path + full_file_name
        File.rename(old_file_path, new_file_path)
        @asset.update_attribute(:file_file_name, full_file_name)
        @new_assets << @asset
        if @asset.stylesheet?
          @new_stylesheets << @asset
        elsif @asset.javascript?
          @new_javascripts << @asset
        elsif @asset.html?
          @new_htmls << @asset
        end
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

  def rename
    @asset = Asset.find params[:asset_id]
    old_file_path = @asset.path + @asset.file_file_name
    new_file_path = @asset.path + params[:new_name]
    File.rename(old_file_path, new_file_path)
    @asset.update_attribute(:file_file_name, params[:new_name])
    render :text => nil, :status => 200
  end

  def activate
    @asset = Asset.find params[:asset_id]
    @asset.update_attribute(:active, 1)
    render :text => nil, :status => 200
  end

  def deactivate
    @asset = Asset.find params[:asset_id]
    @asset.update_attribute(:active, 0)
    render :text => nil, :status => 200
  end

  def download
    # todo need to refactoring. Also need to create download all in archive
    #@asset = Asset.find(params[:asset_id])
    #if @asset.stylesheet? or @asset.javascript?
    #  @lines = ""
    #  file_name = @asset.path + @asset.file_file_name
    #  if File.exist? file_name
    #    file_lines = File.open(file_name).readlines
    #    file_lines.each do |line|
    #      @lines << line
    #    end
    #  else
    #
    #  end
    #else
    #
    #end
    #send_data(@lines, disposition: "inline")
  end

  private

end
