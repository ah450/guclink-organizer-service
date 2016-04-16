class AddsUserToStudentFetchedInfo < ActiveRecord::Migration
  def change
    add_reference :student_fetched_infos, :user
    change_column_null :student_fetched_infos, :user_id, false
    add_foreign_key :student_fetched_infos, :users, on_delete: :cascade
    add_index :student_fetched_infos, :user_id
  end
end
