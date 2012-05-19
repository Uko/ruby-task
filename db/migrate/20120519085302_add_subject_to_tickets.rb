class AddSubjectToTickets < ActiveRecord::Migration
  def up
    add_column :tickets, :subject, :string

		Ticket.reset_column_information
		Ticket.all.each do |ticket|
			ticket.subject = "Missing title"
		  ticket.save!
		end
  end

	def down
		remove_column :tickets, :subject
	end
end
