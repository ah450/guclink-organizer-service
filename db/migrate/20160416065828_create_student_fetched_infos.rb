class CreateStudentFetchedInfos < ActiveRecord::Migration
  def change
    create_table :student_fetched_infos do |t|
      t.integer :guc_id_prefix, null: false
      t.integer :guc_id_suffix, null: false
      t.string :name, null: false
      t.timestamps null: false
    end
    add_index :student_fetched_infos, [:guc_id_prefix, :guc_id_suffix]
  end
end
