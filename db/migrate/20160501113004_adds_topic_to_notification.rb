class AddsTopicToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :topic, :string
  end
end
