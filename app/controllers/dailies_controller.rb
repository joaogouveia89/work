class DailiesController < ApplicationController
  before_action :check_ticket
  before_action :set_daily, only: %i[ show edit update destroy ]
  after_action :update_ticket, only: %i[ create update destroy ]

  # GET /dailies or /dailies.json
  def index
    @today = DateTime.now.to_date
    @dailies = Daily.where(ticket_id: @ticket.id).order(updated_at: :desc)

    @dailies_map = @dailies.group_by { |d| d.updated_at.to_date } 

    @past_days = calculate_past_days @dailies

  end

  # GET /dailies/1 or /dailies/1.json
  def show
  end

  # GET /dailies/new
  def new
    @daily = Daily.new
  end

  # GET /dailies/1/edit
  def edit
  end

  # POST /dailies or /dailies.json
  def create
    @daily = Daily.new(daily_params)
    respond_to do |format|
      if @daily.save
        format.html { redirect_to ticket_dailies_url(@ticket), notice: "Daily was successfully created." }
        format.json { render :show, status: :created, location: @daily }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @daily.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dailies/1 or /dailies/1.json
  def update
    respond_to do |format|
      if @daily.update(daily_params)
        format.html { redirect_to ticket_daily_url(@ticket, @daily), notice: "Daily was successfully updated." }
        format.json { render :show, status: :ok, location: @daily }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @daily.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dailies/1 or /dailies/1.json
  def destroy
    @daily.destroy
    respond_to do |format|
      format.html { redirect_to ticket_dailies_url(@ticket), notice: "Daily was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily
      @daily = Daily.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def daily_params
      params.require(:daily).merge(ticket_id: @ticket.id).permit(:notes, :ticket_id)
    end

    def check_ticket
      @ticket = Ticket.where(id: params[:ticket_id]).first
      if @ticket.nil?
        respond_to do |format|
          format.html { redirect_to tickets_path, notice: "Ticket does not exist." }
          format.json { render :index, status: :unprocessable_entity }
        end
      end
    end

    def calculate_past_days dailies
      if dailies.size == 0
        0
      else
        end_reference = @ticket.open? ? DateTime.now.to_date : dailies.first.updated_at.to_date
        (end_reference -  dailies.last.updated_at.to_date).to_i
      end
    end

    def update_ticket
      @daily.ticket.touch
    end
end
