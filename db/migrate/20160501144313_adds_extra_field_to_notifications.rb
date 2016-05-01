class AddsExtraFieldToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :extra, :json, default: "{}", null: false
  end
end
