class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :type, null: false
      t.string :title, null: false
      t.string :description, null: false

      t.timestamps null: false
    end
    add_index :notifications, :type
  end
end
