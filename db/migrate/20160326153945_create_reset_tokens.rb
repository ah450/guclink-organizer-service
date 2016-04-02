class CreateResetTokens < ActiveRecord::Migration
  def change
    create_table :reset_tokens do |t|
      t.references :user, index: true, foreign_key: true
      t.string :token, null: false

      t.timestamps null: false
    end
    add_index :reset_tokens, [:user_id, :token]
  end
end
