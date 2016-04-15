class GcmOrganizerIdsForeignKey < ActiveRecord::Migration
  def change
    remove_foreign_key "gcm_organizer_ids", "users"
    add_foreign_key "gcm_organizer_ids", "users", on_delete: :cascade
  end
end
