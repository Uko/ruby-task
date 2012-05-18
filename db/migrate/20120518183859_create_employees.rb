class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :login
      t.string :password_digest

      t.timestamps
    end
  end
end
