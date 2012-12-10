class DeleteStoreIdFromCart < ActiveRecord::Migration
  def up
    remove_column :carts, :store_id
  end

  def down
    add_column :carts, :store_id, :integer
  end
end
