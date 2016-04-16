class CreateScheduleSlots < ActiveRecord::Migration
  def change
    create_table :schedule_slots do |t|
      t.references :course, index: true
      t.string :location
      t.string :group
      t.string :name, null: false
      t.integer :day, null: false
      t.integer :slot_num, null: false
      t.boolean :tutorial, null: false
      t.boolean :lecture, null: false
      t.boolean :lab, null: false
      t.timestamps null: false
    end
    add_foreign_key :schedule_slots, :courses, on_delete: :cascade
  end
end
