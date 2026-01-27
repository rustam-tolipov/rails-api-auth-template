class CreateBlacklistedTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :blacklisted_tokens do |t|
      t.string :jti, null: false
      t.references :user, null: false, foreign_key: true
      t.datetime :exp, null: false

      t.timestamps
    end

    add_index :blacklisted_tokens, :jti, unique: true
    add_index :blacklisted_tokens, :exp
  end
end
