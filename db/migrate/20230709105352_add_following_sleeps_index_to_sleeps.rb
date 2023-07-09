class AddFollowingSleepsIndexToSleeps < ActiveRecord::Migration[7.0]
  def change
    add_index :sleeps, "user_id, DATE(started_at), duration", name: "index_sleeps_on_day_by_duration"
  end
end
