class NotificationCreatedAtIndex < ActiveRecord::Migration
  def change
    add_index :notifications, :created_at, order: :desc
  end
end
