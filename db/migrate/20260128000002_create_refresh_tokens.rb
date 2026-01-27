class CreateRefreshTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :refresh_tokens do |t|
      t.string :token, null: false
      t.references :user, null: false, foreign_key: true
      t.datetime :expires_at, null: false
      t.boolean :revoked, default: false

      t.timestamps
    end

    add_index :refresh_tokens, :token, unique: true
    add_index :refresh_tokens, [:user_id, :revoked]
  end
end
