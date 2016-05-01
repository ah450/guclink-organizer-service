class ChangesNotificationTypeDefault < ActiveRecord::Migration
  def change
    change_column_default :notifications, :type, 'Notification'
  end
end
