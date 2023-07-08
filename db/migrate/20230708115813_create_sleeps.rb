class CreateSleeps < ActiveRecord::Migration[7.0]
  def change
    create_table :sleeps do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.virtual :duration, type: :interval, as: "AGE(ended_at, started_at)", stored: true
      t.timestamps
      t.index %i(user_id started_at)
    end
  end
end
