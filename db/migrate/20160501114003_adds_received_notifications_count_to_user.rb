class AddsReceivedNotificationsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :received_notifications_count, :integer, null: false, default: 0
  end
end
