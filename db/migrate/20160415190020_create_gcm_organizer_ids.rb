class CreateGcmOrganizerIds < ActiveRecord::Migration
  def change
    create_table :gcm_organizer_ids do |t|
      t.references :user, index: true, foreign_key: true
      t.string :gcm, null: false
      t.timestamps null: false
    end
  end
end
