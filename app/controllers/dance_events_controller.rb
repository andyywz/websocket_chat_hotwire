class DanceEventsController < ApplicationController
  before_action :set_dance_event, only: %i[ show edit update destroy ]

  # GET /dance_events or /dance_events.json
  def index
    @dance_events = DanceEvent.all
  end

  # GET /dance_events/1 or /dance_events/1.json
  def show
  end

  # GET /dance_events/new
  def new
    @dance_event = DanceEvent.new
  end

  # GET /dance_events/1/edit
  def edit
  end

  # POST /dance_events or /dance_events.json
  def create
    @dance_event = DanceEvent.new(dance_event_params)

    respond_to do |format|
      if @dance_event.save
        format.html { redirect_to dance_event_url(@dance_event), notice: "Dance event was successfully created." }
        format.json { render :show, status: :created, location: @dance_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dance_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dance_events/1 or /dance_events/1.json
  def update
    respond_to do |format|
      if @dance_event.update(dance_event_params)
        format.html { redirect_to dance_event_url(@dance_event), notice: "Dance event was successfully updated." }
        format.json { render :show, status: :ok, location: @dance_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dance_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dance_events/1 or /dance_events/1.json
  def destroy
    @dance_event.destroy

    respond_to do |format|
      format.html { redirect_to dance_events_url, notice: "Dance event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dance_event
      @dance_event = DanceEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dance_event_params
      params.fetch(:dance_event, {})
    end
end