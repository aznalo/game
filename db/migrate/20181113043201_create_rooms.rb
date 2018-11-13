class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string     :name, null: false, default: 'No Name'
      t.string     :password_digest
      t.integer    :status, null: false, default: 0
      t.timestamps null: false
    end
  end
end
