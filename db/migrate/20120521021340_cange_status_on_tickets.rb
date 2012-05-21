class CangeStatusOnTickets < ActiveRecord::Migration
  def up
		
		tickets = Ticket.all
		
		cache = {}
		
		tickets.each do |ticket|
			cache[ticket.id] = ticket[:status]
		end
		
		
		change_table :tickets do |t|
		  t.remove :status
			t.references :status	
		end
		
		Ticket.reset_column_information
		cache.each do |id, status|
			ticket =  Ticket.find(id)
			Status.create!(status) unless Status.exists?(:name => status)
			
			ticket.status = Status.find_by_name status
			ticket.save!
		end
  end

  def down
	
		tickets = Ticket.all
	
		cache = {}
		
		tickets.each do |ticket|
			cache[ticket.id] = ticket.status.name
		end
	
		change_table :tickets do |t|
		  t.string :status
			t.remove :status_id
		end
		
		
		Ticket.reset_column_information
		cache.each do |id, status|
			ticket =  Ticket.find(id)
			ticket.status = status
			ticket.save!
		end
		

  end
end
