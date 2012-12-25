class AddStorageLimitToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storage_limit, :integer
  end
end
