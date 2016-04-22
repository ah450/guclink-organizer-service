class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.integer :num_likes, null: false, default: 0
      t.timestamps null: false
    end
    add_index :events, :created_at
  end
end
