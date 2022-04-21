class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.string :name
      t.integer :number, :unique => true
      t.string :application_id, :null => false

      t.timestamps
    end
    add_foreign_key :chats, :applications, column: :application_id, primary_key: "token", on_delete: :cascade
    add_index :chats, [:number, :application_id], unique: true
  end
end
