class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.references :course, index: true
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :location, null: false
      t.string :seat, null: false
      t.string :exam_type, null: false
      t.timestamps null: false
    end
    add_foreign_key :exams, :courses, on_delete: :cascade
  end
end
