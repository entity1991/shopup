class CreateJoinConfirmations < ActiveRecord::Migration
  def change
    create_table :join_confirmations do |t|
      t.integer :user_id
      t.string :activation_code
      t.timestamps
      end
  end
end
