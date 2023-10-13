module DanceEventParticipantsHelper
  def users_options(participant_ids = [])
    if participant_ids.present?
      User.where.not(id: participant_ids).pluck(:email, :id)
    else
      User.pluck(:email, :id)
    end
  end
end
