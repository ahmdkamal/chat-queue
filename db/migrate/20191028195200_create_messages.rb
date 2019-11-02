class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      ##
      # Columns
      ##
      t.column :message_number, :integer, nullable: true
      t.integer :chat_number
      t.string :body
      t.timestamps
      ##
      # indices
      ##
      t.index :body
      t.index :chat_number
    end
  end
end
