class TicketsController < ApplicationController
  # GET /tickets
  # GET /tickets.json
  def index
		session[:email] = params[:email] if params.key? :email
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticket }
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

    respond_to do |format|
      if @ticket.save
				CustomerSupport.notification_email(@ticket).deliver
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render json: @ticket, status: :created, location: @ticket }
      else
        format.html { render action: "new" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

	# GET /tickets/login
	def login
		@email = session[:email]
	end
	
	# GET /tickets/logout
	def logout
		session[:email] = nil
		redirect_to tickets_path
	end
end
