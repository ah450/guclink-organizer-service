class AddsUsersFkToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :sender_id, :integer
    add_column :notifications, :receiver_id, :integer
    add_foreign_key :notifications, :users, column: :sender_id, on_delete: :nullify
    add_foreign_key :notifications, :users, column: :receiver_id, on_delete: :nullify
    add_index :notifications, :sender_id
    add_index :notifications, :receiver_id
  end
end
