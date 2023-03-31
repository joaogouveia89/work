class LinksController < ApplicationController
  before_action :set_link, only: %i[ show edit update destroy ]
  before_action :check_ticket

  # GET /links or /links.json
  def index
    @links = Link.all
    @link = Link.new
  end

  # GET /links/1 or /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links or /links.json
  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to ticket_links_url(@ticket), notice: "Link was successfully created." }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1 or /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to ticket_links_url(@ticket), notice: "Link was successfully updated." }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1 or /links/1.json
  def destroy
    @link.destroy

    respond_to do |format|
      format.html { redirect_to ticket_links_url(@ticket), notice: "Link was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
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

    # Only allow a list of trusted parameters through.
    def link_params
      params.require(:link).merge(ticket_id: @ticket.id).permit(:ticket_id, :label, :url)
    end
end
