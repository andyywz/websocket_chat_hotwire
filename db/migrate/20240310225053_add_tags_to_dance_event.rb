class AddTagsToDanceEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :dance_events, :tags, :text, array: true, default: []
    add_index :dance_events, :tags, using: 'gin'
  end
end
