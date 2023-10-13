class DanceEventParticipantsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]
  before_action :verify_dance_event_and_user, only: %i[create]

  def new
    @dance_event = DanceEvent.find(params[:dance_event_id])
    @participant = DanceEventParticipant.new
  end

  def create
    @dance_event_participant = DanceEventParticipant.new(participant_params)

    if @dance_event_participant.save
      redirect_to dance_event_url(@dance_event), notice: "User successfully registered."
    else
      redirect_to new_dance_event_dance_event_participant_url(@dance_event),
                  notice: "User was already registered to this event."
      # render :new, status: :unprocessable_entity
    end
  end

  def destroy
    participation = DanceEventParticipant.find(params[:id])
    notice = if participation.destroy
               "#{participation.user.email} was successfully unregistered."
             else
               "Dance event participant could not be destroyed."
             end
    redirect_to dance_event_url(participation.dance_event), notice:
  end

  private

  def verify_dance_event_and_user
    @dance_event = DanceEvent.find(participant_params[:dance_event_id])
    @user = User.find(participant_params[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    redirect_to dance_events_url, warning: "Error occured! #{e.message}"
  end

  def participant_params
    params.fetch(:dance_event_participant, {}).permit(:dance_event_id, :user_id)
  end
end
