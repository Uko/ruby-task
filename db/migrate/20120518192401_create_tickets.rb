class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :customer_name
      t.string :customer_mail
      t.string :department
      t.string :status
      t.references :employee

      t.timestamps
    end
    add_index :tickets, :employee_id
  end
end
