class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.column :number, :integer
      t.integer :chat_number
      t.string :body
      t.index :body
      t.timestamps
    end
  end
end
