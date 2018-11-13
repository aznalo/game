class CreateUserTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tokens do |t|
      t.integer  :user_id,         null: false
      t.string   :uuid
      t.datetime :expiration_time, null: false
      t.timestamps                 null: false
    end
  end
end
