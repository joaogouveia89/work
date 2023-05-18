class JournalsController < ApplicationController
  before_action :set_journal, only: %i[ show edit update destroy ]
  before_action :reference_dates, only: %i[ index edit ]

  # GET /journals or /journals.json
  def index
    @journals = Journal.where(updated_at: [@month_first_day..(@month_last_day)])
    @today_journal = @journals.select{ |j| j.updated_at.to_date == @today.to_date }.first
    @calendar_days = get_calendar_days

    @business_days = @month_days.filter{ |d| d.wday > 0 && d.wday < 6 }.size

    @show_next_month = @today.month != @reference_date.month

    @show_previous_month = @reference_date.month != (Journal.order(:updated_at).limit(1).pluck(:updated_at).first.month)

  end

  # GET /journals/1 or /journals/1.json
  def show
    respond_to do |format|
      format.js{ render layout: false}
    end
  end

  # GET /journals/new
  def new
    @journal = Journal.new
  end

  # GET /journals/1/edit
  def edit
    if Journal.find(params[:id].to_i).updated_at.to_date != @reference_date.to_date
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
        format.html { redirect_to journals_path, notice: "Journal was successfully created." }
        format.json { render :index, status: :created, location: @journal }
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
        format.html { redirect_to journals_path, notice: "Journal was successfully updated." }
        format.json { render :index, status: :ok, location: @journal }
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
    IS_MONTH = /^(0?[1-9]|1[012])$/
    IS_INTEGER = /\A\d+\z/

    # Use callbacks to share common setup or constraints between actions.
    def set_journal
      @journal = Journal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def journal_params
      params.require(:journal).permit(:meetings, :current_task, :team_interaction, :humor, :comments)
    end

    def reference_dates
      @today = Date.today
      @reference_date = (!valid_param_month || !valid_param_year || (params[:m].to_i == @today.month && params[:y].to_i == @today.year)) ? @today : Date.new(params[:y].to_i, params[:m].to_i, 1)
      @month_first_day = @reference_date.beginning_of_month
      @month_last_day = @reference_date.end_of_month

      @month_days = ((@month_first_day)..( @month_last_day)).to_a
      
      @previous_month = (@month_first_day - 1)
      @next_month = (@month_last_day + 1)
    end

    def get_calendar_days
       last_month_days = @month_first_day.wday == 0 ? [] : (((@month_first_day - (@month_first_day.wday))..@month_first_day).to_a)[0...-1]
       next_month_days = @month_last_day.wday == 6 ? [] : (( (@month_last_day + 1)..( @month_last_day + (6 -  @month_last_day.wday))).to_a)

       calendar_days = last_month_days + @month_days + next_month_days

       (calendar_days.each_slice(7)).to_a
    end

    def valid_param_month
      (params[:m] != nil && params[:m] =~ IS_MONTH)
    end

    def valid_param_year
      (params[:y] != nil && params[:y] =~ IS_INTEGER && params[:y].size == 4)
    end
end
