class AddsRejectedToEventInvitations < ActiveRecord::Migration
  def change
    add_column :event_invitations, :rejected, :boolean, default: false, null: false
  end
end
