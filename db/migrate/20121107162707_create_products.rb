class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.decimal :price
      t.integer :store_id

      t.timestamps
    end
  end
end
