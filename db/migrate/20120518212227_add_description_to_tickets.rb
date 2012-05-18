class AddDescriptionToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :description, :text
  end
end
