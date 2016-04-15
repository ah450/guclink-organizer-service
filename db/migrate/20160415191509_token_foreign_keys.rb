class TokenForeignKeys < ActiveRecord::Migration
  def change
    remove_foreign_key :verification_tokens, :users
    remove_foreign_key :reset_tokens, :users
    add_foreign_key :verification_tokens, :users, on_delete: :cascade
    add_foreign_key :reset_tokens, :users, on_delete: :cascade
  end
end
