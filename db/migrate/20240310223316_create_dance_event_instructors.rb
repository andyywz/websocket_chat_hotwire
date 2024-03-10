class CreateDanceEventInstructors < ActiveRecord::Migration[7.0]
  def change
    create_table :dance_event_instructors do |t|
      t.references :dance_event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
