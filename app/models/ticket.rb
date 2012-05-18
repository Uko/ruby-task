class Ticket < ActiveRecord::Base
  belongs_to :employee
  attr_accessible :customer_mail, :customer_name, :department, :status
end
