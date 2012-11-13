class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :content_type
      t.string :title
      t.integer :category_id

      t.timestamps
    end
  end
end
