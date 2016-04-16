class CreateStudentRegistrations < ActiveRecord::Migration
  def change
    create_table :student_registrations do |t|
      t.references :user, index: true
      t.references :schedule_slot, index: true
      t.timestamps null: false
    end
    add_foreign_key :student_registrations, :users, on_delete: :cascade
    add_foreign_key :student_registrations, :schedule_slots, on_delete: :cascade
  end
end
