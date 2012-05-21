class CustomerSupport < ActionMailer::Base
  default from: "noreply@onapp.com"

	def new_ticket_email(ticket)
		@ticket = ticket
	  mail(:to => ticket.customer_mail, :subject => "Ticket created")
	end
	
	def update_ticket_email(ticket, reply)
		@ticket = ticket
		@reply = reply
		mail(:to => ticket.customer_mail, :subject => "Update on your ticket: #{ticket.subject}")
	end
	
end
