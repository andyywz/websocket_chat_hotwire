class ProcessDanceParticipantsCsv
  def self.perform(dance_event_id:, csv:)
    new(dance_event_id, csv).send(:perform)
  end

  private

  def initialize(dance_event_id, csv)
    @csv = CSV.read(csv)
    @dance_event = DanceEvent.find(dance_event_id)
  end

  def perform
    validate_headers
    emails = @csv[1..].map(&:first)

    already_registered = DanceEventParticipant.joins(:user)
      .where(user: { email: emails }, dance_event_id: @dance_event).pluck(:email)
    to_be_registered = User.where(email: emails - already_registered)
    not_found = emails - already_registered - to_be_registered.pluck(:email)

    register_users(to_be_registered)

    [to_be_registered.count, already_registered.count, not_found]
  end

  def register_users(users)
    @dance_event.dance_event_participants.create(users.map { |user| { user_id: user.id } })
  end

  def validate_headers
    raise unless @csv[0] == ["email"]
  end
end
