class AddsPrivateFlagToEvent < ActiveRecord::Migration
  def change
    add_column :events, :private, :boolean, default: false, null: false
  end
end
