class ApplicationController < ActionController::Base
  protect_from_forgery

	private
	
	def current_employee
		Employee.find session[:employee_id]
	end
	
	helper_method :current_employee
end
