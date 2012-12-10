class AddCaptureToStore < ActiveRecord::Migration
  def change
    add_column :stores, :capture, :string
  end
end
