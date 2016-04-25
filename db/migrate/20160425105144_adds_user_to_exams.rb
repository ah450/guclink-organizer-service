class AddsUserToExams < ActiveRecord::Migration
  def change
    add_column :exams, :user_id, :integer
    add_index :exams, :user_id
    add_foreign_key :exams, :users
  end
end
