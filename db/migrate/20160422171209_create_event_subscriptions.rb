class CreateEventSubscriptions < ActiveRecord::Migration
  def change
    create_table :event_subscriptions do |t|
      t.references :event, index: true
      t.references :user, index: true
      t.timestamps null: false
    end
    add_foreign_key :event_subscriptions, :events, on_delete: :cascade
    add_foreign_key :event_subscriptions, :users, on_delete: :cascade
  end
end
