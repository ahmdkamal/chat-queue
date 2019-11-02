class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      ##
      # Columns
      ##
      t.column :chat_number, :integer, nullable: true
      t.string :application_token
      t.column :messages_count, :integer, :default => 0
      t.timestamps
      ##
      # indices
      ##
      t.index :application_token
    end
  end
end
