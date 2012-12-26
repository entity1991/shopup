class AddActiveToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :active, :boolean, default: false
  end
end
