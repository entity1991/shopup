class JoinFieldsAndCategories < ActiveRecord::Migration
  def up
    # Create the association table
    create_table :categories_fields, :id => false do |t|
      t.integer :category_id, :null => false
      t.integer :field_id, :null => false
    end

    # Add table index
    add_index :categories_fields, [:category_id, :field_id], :unique => true

  end

  def down
    remove_index :categories_fields, :column => [:category_id, :field_id]
    drop_table :categories_fields
  end
end
