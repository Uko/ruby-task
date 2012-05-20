class Backend::TicketsController < Backend::ApplicationController
  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.all
		puts @tickets
		puts "elllllp"
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
		unless params[:ticket][:employee_id].to_i == @ticket.employee.id
			changes += "> Responsible changed from #{@ticket.employee.login} to #{Employee.find(params[:ticket][:employee_id]).login}"
			@ticket.employee = Employee.find(params[:ticket][:employee_id])
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
