class CreateFieldContents < ActiveRecord::Migration
  def change
    create_table :field_contents do |t|
      t.integer :product_id
      t.integer :field_id
      t.string :content

    end
  end
end
