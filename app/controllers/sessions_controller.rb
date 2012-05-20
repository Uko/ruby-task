class SessionsController < ApplicationController
  def new
		@login = current_user.login unless current_user.nil?
  end

  def create
	  employee = Employee.find_by_login(params[:login])
	  if employee && employee.authenticate(params[:password])
	    session[:employee_id] = employee.id
	    redirect_to backend_root_path, :notice => "Logged in!"
	  else
	    flash.now.alert = "Invalid login or password"
	    render "new"
	  end
	end

	def destroy
	  session[:employee_id] = nil
	  redirect_to root_url, :notice => "Logged out!"
	end
end
