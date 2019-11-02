class CreateApplicationsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.column :name, :string, :limit => 32, :null => false
      t.string :application_token, :limit => 32
      t.column :chats_count, :integer, :default => 0
      t.timestamps
    end
  end
end
