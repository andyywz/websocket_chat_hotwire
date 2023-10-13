class CreateDanceEventParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :dance_event_participants do |t|
      t.references :dance_event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :dance_event_participants, [:dance_event_id, :user_id], unique: true
  end
end
