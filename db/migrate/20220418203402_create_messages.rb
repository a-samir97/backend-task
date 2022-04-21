class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :number, :unique => true
      t.string :content
      t.integer :chat_id, :null => false
      t.timestamps
    end
    add_foreign_key :messages, :chats, column: :chat_id, primary_key: "number", on_delete: :cascade
    add_index :messages, [:chat_id, :number], unique: true
  end
end
