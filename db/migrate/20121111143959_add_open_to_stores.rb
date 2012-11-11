class AddOpenToStores < ActiveRecord::Migration
  def change
    add_column :stores, :open, :boolean
  end
end
