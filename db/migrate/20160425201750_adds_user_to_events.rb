class AddsUserToEvents < ActiveRecord::Migration
  def change
    add_column :events, :user_id, :integer
    add_foreign_key :events, :users, on_delete: :cascade
  end
end
