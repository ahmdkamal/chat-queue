class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      t.column :number, :integer
      t.string :token
      t.column :messages_count, :integer, :default => 0
      t.timestamps
    end
  end
end
