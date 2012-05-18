class Employee < ActiveRecord::Base
  attr_accessible :login, :password_digest
	has_secure_password
	
	validates :login, :password_digest, :presence => true
end
