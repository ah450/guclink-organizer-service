class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest, null: false
      t.boolean :student, null: false
      t.boolean :verified, null: false, default: false
      t.boolean :super_user, null: false, default: false

      t.timestamps null: false
    end
    add_index :users, :email
    add_index :users, :name
    add_index :users, :student
    add_index :users, :super_user
  end
end
