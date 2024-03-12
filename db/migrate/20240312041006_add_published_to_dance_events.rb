class AddPublishedToDanceEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :dance_events, :published, :boolean, default: false
    add_index :dance_events, :published
  end
end
