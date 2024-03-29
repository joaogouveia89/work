include DateHelper

class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tickets = Ticket.order(:status, "updated_at DESC")
    @today = today
    fifteen_days_ago = (@today - 15.days).to_date

    @last_15_days_tickets = @tickets.filter do |ticket|
      ticket.updated_at.to_date >= fifteen_days_ago
    end

    @tickets -= @last_15_days_tickets

    unless @tickets.find{ |t| !t.closed? }.nil?
      flash[:notice] = "There's a non closed ticket for more than 15 days"
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    @last_dailies = @ticket.dailies.order(:status, "updated_at DESC").limit(3)
    @links = @ticket.links
    @daily = Daily.new
    @link = Link.new
  end

  # GET /tasks/new
  def new
    @ticket = Ticket.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.status = Ticket.statuses[:open]

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to tickets_url, notice: "Ticket was successfully created." }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to tickets_url, notice: "Ticket was successfully updated." }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to tickets_url, notice: "Ticket was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ticket_params
      params.require(:ticket).permit(:name, :status)
    end
end
