class ImprovesEventSubscriptionIndex < ActiveRecord::Migration
  def change
    remove_index :event_subscriptions, :user_id
    remove_index :event_subscriptions, :event_id
    add_index :event_subscriptions, [:user_id, :event_id]
  end
end
