module TicketsHelper
	
	def available_departments
		Ticket.all_departments
	end
	
	def available_statuses
		Ticket.all_statuses
	end
	
end
