class NotificationTopicIndex < ActiveRecord::Migration
  def change
    add_index :notifications, :topic, where: "topic IS NOT NULL"
  end
end
