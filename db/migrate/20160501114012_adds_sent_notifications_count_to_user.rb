class AddsSentNotificationsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :sent_notifications_count, :integer, null: false, default: 0
  end
end
