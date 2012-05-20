class ApplicationController < ActionController::Base
  protect_from_forgery

	private

	def current_user
		session[:employee_id]? Employee.find(session[:employee_id]) : nil
	end
	
	def authenticate
		if current_user.nil?
			render :status => :forbidden, :text => "Forbidden!!!"
		end
	end
	
	helper_method :current_user
end
