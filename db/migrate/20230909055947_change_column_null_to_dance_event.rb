class ChangeColumnNullToDanceEvent < ActiveRecord::Migration[7.0]
  def change
    change_column_null :dance_events, :country, false
    change_column_null :dance_events, :name, false
    change_column_null :dance_events, :user_id, false
  end
end
