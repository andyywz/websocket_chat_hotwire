class AddDetailsToDanceEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :dance_events, :start_date, :date
    add_column :dance_events, :end_date, :date
    add_column :dance_events, :country, :string
    add_column :dance_events, :city, :string
    add_column :dance_events, :website, :string
    add_reference :dance_events, :user, null: true, foreign_key: true
  end
end
