class Backend::TicketsController < Backend::ApplicationController
  # GET /tickets
  # GET /tickets.json
  def index
		unless %w(new open hold closed).include?(params[:scope])
			redirect_to backend_tickets_path :scope => "new"
			return
		end
		case params[:scope]
			when "new"
				@tickets = Ticket.order("updated_at DESC").where(:employee_id => nil)
			when "open"
				@tickets = (Status.find_by_name('Waiting for Staff Response').tickets+Status.find_by_name('Waiting for Customer').tickets).sort_by {|ticket| -ticket.updated_at.to_f}
			when "hold"
				@tickets = Status.find_by_name('On Hold').tickets.order("updated_at DESC")
			when "closed"
					@tickets = @tickets = (Status.find_by_name('Cancelled').tickets+Status.find_by_name('Completed').tickets).sort_by {|ticket| -ticket.updated_at.to_f}
		end
		@scope = params[:scope]
    #@tickets = Ticket.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tickets }
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    @ticket = Ticket.find(params[:id])
		@reply = @ticket.replies.build
		
		@scope = params[:scope]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticket }
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.json
  def update
    @ticket = Ticket.find(params[:id])
		changes = ""
		new_employee = params[:ticket][:employee_id].nil? || params[:ticket][:employee_id].empty?  ? nil : Employee.find(params[:ticket][:employee_id])
		unless new_employee == @ticket.employee
			changes += "> Responsible changed from #{@ticket.employee ? @ticket.employee.login : "None"} to #{new_employee.login}"
			@ticket.employee = new_employee
		end
		new_status = params[:ticket][:status_id].nil? || params[:ticket][:status_id].empty?  ? nil : Status.find(params[:ticket][:status_id])
		unless new_status == @ticket.status
			changes += $/ + "> Status changed from \"#{@ticket.status ? @ticket.status.name : "None"}\" to \"#{new_status.name}\""
			@ticket.status = new_status
		end
		@reply = @ticket.replies.build(params[:reply])
		@reply.meta = changes
		@reply.author = current_user.login
    respond_to do |format|
      if @ticket.valid? && @reply.valid?
				@ticket.save
				@reply.save
				CustomerSupport.update_ticket_email(@ticket,@reply).deliver
        format.html { redirect_to backend_ticket_path(@ticket), notice: 'Ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "show" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

	def search
		if params[:search][:search].empty?
			@tickets = []
		else
			if Ticket.exists? params[:search][:search]
				redirect_to backend_ticket_path Ticket.find params[:search][:search]
			else
				@tickets = Ticket.order("updated_at DESC").where('subject LIKE ?', "%#{params[:search][:search]}%").all
			end
		end
	end

end
