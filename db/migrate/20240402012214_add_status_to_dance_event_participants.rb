class AddStatusToDanceEventParticipants < ActiveRecord::Migration[7.1]
  def change
    add_column :dance_event_participants, :status, :string, default: 'registered'
    add_index :dance_event_participants, :status
  end
end
