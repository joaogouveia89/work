class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tickets = Ticket.all

    @last_update = Hash.new

    @tickets.each do|ticket|
      # if there is a ticket daily which is most recent comparing to ticket update, the last update is this daily date
      last_daily = Daily.where(ticket_id: ticket.id).order(updated_at: :desc).limit(1).first
      @last_update[ticket.id] = [last_daily.updated_at, ticket.updated_at].max
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
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
        format.html { redirect_to ticket_url(@ticket), notice: "Task was successfully created." }
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
      if @ticket.update(task_params)
        format.html { redirect_to ticket_url(@ticket), notice: "Task was successfully updated." }
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
      format.html { redirect_to tickets_url, notice: "Task was successfully destroyed." }
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
      params.require(:ticket).permit(:name)
    end
end
