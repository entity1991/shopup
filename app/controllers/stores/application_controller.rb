class Stores::ApplicationController < ApplicationController

  before_filter :current_store
  before_filter :stylesheets

  layout "stores/application"

  private

  def current_store
    @store ||= Store.find(params[:store_id])
  end

  def stylesheets
    @styles = current_store.stylesheets
    @lines = []
    @styles.each do |css|
      file_name = "./public/assets/store_assets/" + css.id.to_s + "/original/" + css.file_file_name
      if File.exist? file_name
        file_lines = File.open(file_name).readlines
        file_lines.each do |line|
          @lines << line
        end
      else

      end
    end
  end

end
