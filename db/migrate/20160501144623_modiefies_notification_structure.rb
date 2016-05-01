class ModiefiesNotificationStructure < ActiveRecord::Migration
  def change
    remove_column :notifications, :title
    remove_column :notifications, :description
    rename_column :notifications, :extra, :data
  end
end
