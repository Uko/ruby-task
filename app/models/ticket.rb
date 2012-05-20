class Ticket < ActiveRecord::Base
  belongs_to :employee
  attr_accessible :customer_mail, :customer_name, :subject, :department, :description, :status, :employee_id
	
	has_many :replies, :dependent => :destroy

	after_initialize :default_values

	def self.all_departments()
		%w(billing documentation technical)
	end

	def self.all_statuses
		['Waiting for Staff Response', 'Waiting for Customer', 'On Hold', 'Cancelled', 'Completed']
	end

	validates :customer_mail, :customer_name, :department, :subject, :presence => true
	validates :customer_mail, :format => { :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }
	validates :department, :inclusion => { :in => Ticket.all_departments()}
	validates :status, :inclusion => { :in => Ticket.all_statuses}
	
	private
    def default_values
      self.status ||= 'Waiting for Staff Response'
    end
	
end
