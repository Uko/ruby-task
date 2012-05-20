class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :text
			t.string :meta
      t.references :ticket

      t.timestamps
    end
    add_index :replies, :ticket_id
  end
end
