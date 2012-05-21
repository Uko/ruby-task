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
				@tickets = Ticket.order("updated_at DESC").find_all_by_status(['Waiting for Customer', 'Waiting for Staff Response'])
			when "hold"
				@tickets = Ticket.order("updated_at DESC").find_all_by_status('On Hold')
			when "closed"
					@tickets = Ticket.order("updated_at DESC").find_all_by_status(['Cancelled', 'Completed'])
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

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
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
		unless params[:ticket][:status] == @ticket.status
			changes += $/ + "> Status changed from \"#{@ticket.status}\" to \"#{params[:ticket][:status]}\""
			@ticket.status = params[:ticket][:status]
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

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to tickets_url }
      format.json { head :no_content }
    end
  end
end
