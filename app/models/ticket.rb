class Ticket < ActiveRecord::Base
  belongs_to :employee
	belongs_to :status
  attr_accessible :customer_mail, :customer_name, :subject, :department, :description, :employee_id
	
	has_many :replies, :dependent => :destroy

	def self.all_departments()
		%w(billing documentation technical)
	end

	def self.all_statuses
		Status.all
	end

	validates :customer_mail, :customer_name, :department, :subject, :status, :presence => true
	validates :customer_mail, :format => { :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }
	validates :department, :inclusion => { :in => Ticket.all_departments()}

	
end
