class Ticket < ActiveRecord::Base
  belongs_to :employee
  attr_accessible :customer_mail, :customer_name, :department, :status

	validates :customer_mail, :customer_name, :department, :presence => true
	validates :department, :inclusion => { :in => self.all_departments}
	validates :status, :inclusion => { :in => self.all_statuses}
	
	def self.all_departments
		%w(billing documentation technical)
	end
	
	def self.all_statuses
		['Waiting for Staff Response', 'Waiting for Customer', 'On Hold', 'Cancelled', 'Completed']
	end
end
