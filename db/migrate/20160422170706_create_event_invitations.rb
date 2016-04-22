class CreateEventInvitations < ActiveRecord::Migration
  def change
    create_table :event_invitations do |t|
      t.references :event, index: true
      t.references :user, index: true
      t.timestamps null: false
    end
    add_foreign_key :event_invitations, :events, on_delete: :cascade
    add_foreign_key :event_invitations, :users, on_delete: :cascade
  end
end
