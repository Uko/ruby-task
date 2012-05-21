class TicketsController < ApplicationController
  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.find_all_by_customer_mail session[:email] unless session[:email].nil?
		@email = session[:email]
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

		if @ticket.customer_mail != session[:email]
			session[:path] = ticket_path @ticket
			redirect_to login_tickets_path, notice: 'Please enter an email that is associated with a ticket you are trying to access'
		else
    	respond_to do |format|
      	format.html # show.html.erb
      	format.json { render json: @ticket }
    	end
		end
  end

  # GET /tickets/new
  # GET /tickets/new.json
  def new
    @ticket = Ticket.new
		@ticket.customer_mail ||= session[:email]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ticket }
    end
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(params[:ticket])
		@ticket.status ||= Status.find_by_name 'Waiting for Staff Response'
    respond_to do |format|
      if @ticket.save
				session[:email] = params[:ticket][:customer_mail]
				CustomerSupport.new_ticket_email(@ticket).deliver
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render json: @ticket, status: :created, location: @ticket }
      else
        format.html { render action: "new" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

	# PUT /tickets/1
  # PUT /tickets/1.json
  def update
    @ticket = Ticket.find(params[:id])
		@ticket.status = 'Waiting for Staff Response'
		@reply = @ticket.replies.build(params[:reply])
		@reply.author = @ticket.customer_name
    respond_to do |format|
      if @reply.save
				@ticket.save
        format.html { redirect_to ticket_path(@ticket), notice: 'Ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "show" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

	# GET /tickets/login
	def login
		@email = session[:email]
	end
	
	def authenticate
		session[:email] = params[:email] if params.key? :email
		redirect_to session[:path] || tickets_path
		session[:path] = nil
	end
	
	# GET /tickets/logout
	def logout
		session[:email] = nil
		redirect_to tickets_path
	end
end
