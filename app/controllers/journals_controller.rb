class JournalsController < ApplicationController
  before_action :set_journal, only: %i[ show edit update destroy ]
  before_action :today_relatives, only: %i[ index edit ]

  # GET /journals or /journals.json
  def index
    @journals = Journal.where(updated_at: [@month_first_day..(@month_last_day)])
    @today_journal = @journals.select{ |j| j.updated_at.to_date == @today.to_date }.first
    @month_days = get_calendar_days
  end

  # GET /journals/1 or /journals/1.json
  def show
  end

  # GET /journals/new
  def new
    @journal = Journal.new
  end

  # GET /journals/1/edit
  def edit
    if Journal.find(params[:id].to_i).updated_at.to_date != @today.to_date
      respond_to do |format|
        format.html { redirect_to journals_url, notice: "Não se pode editar um journal diferente do dia de hoje" }
      end
    end
  end

  # POST /journals or /journals.json
  def create
    @journal = Journal.new(journal_params)

    respond_to do |format|
      if @journal.save
        format.html { redirect_to journal_url(@journal), notice: "Journal was successfully created." }
        format.json { render :show, status: :created, location: @journal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /journals/1 or /journals/1.json
  def update
    respond_to do |format|
      if @journal.update(journal_params)
        format.html { redirect_to journal_url(@journal), notice: "Journal was successfully updated." }
        format.json { render :show, status: :ok, location: @journal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /journals/1 or /journals/1.json
  def destroy
    @journal.destroy

    respond_to do |format|
      format.html { redirect_to journals_url, notice: "Journal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journal
      @journal = Journal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def journal_params
      params.require(:journal).permit(:meetings, :current_task, :team_interaction, :humor, :comments)
    end

    def today_relatives
      @today = Date.today
      @month_first_day = @today.beginning_of_month
      @month_last_day = @today.end_of_month
    end

    def get_calendar_days
       
       month_days = ((@month_first_day)..( @month_last_day)).to_a

       last_month_days = (((@month_first_day - (@month_first_day.wday - 1))..@month_first_day).to_a)[0...-1]
       next_month_days = (( @month_last_day..( @month_last_day + (6 -  @month_last_day.wday))).to_a)

       calendar_days = last_month_days + month_days + next_month_days

       (calendar_days.each_slice(7)).to_a
    end
end
