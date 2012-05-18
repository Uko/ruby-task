class CustomerSupport < ActionMailer::Base
  default from: "noreply@onapp.com"

	def notification_email(ticket)
	    @ticket = ticket
	    mail(:to => ticket.customer_mail, :subject => "Ticket created")
	  end
end
