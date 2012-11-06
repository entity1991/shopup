class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :domain
      t.integer :owner_id

      t.timestamps
    end
  end
end
