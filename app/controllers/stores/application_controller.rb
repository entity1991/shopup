class Stores::ApplicationController < ApplicationController

  before_filter :current_store
  before_filter :stylesheets, :javascripts

  layout "stores/application"

  private

  def current_store
    @store ||= Store.find(params[:store_id])
  end

  def stylesheets
    @styles = current_store.stylesheets
    @css_lines = []
    @styles.each do |css|
      file_name = "./public/assets/store_assets/" + css.id.to_s + "/original/" + css.file_file_name
      if File.exist? file_name
        file_lines = File.open(file_name).readlines
        file_lines.each do |line|
          @css_lines << line
        end
      else

      end
    end
  end

  def javascripts
    @javascripts = current_store.javascripts
    @js_lines = []
    @javascripts.each do |js|
      file_name = "./public/assets/store_assets/" + js.id.to_s + "/original/" + js.file_file_name
      if File.exist? file_name
        file_lines = File.open(file_name).readlines
        file_lines.each do |line|
          @js_lines << line
        end
      else

      end
    end
  end

end
