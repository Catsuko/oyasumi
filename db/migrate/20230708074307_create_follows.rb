class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.references :user, index: false, foreign_key: true, null: false
      t.references :followed_user, index: false, foreign_key: { to_table: :users }, null: false
      t.index %i(user_id followed_user_id), unique: true
      t.timestamps
    end
  end
end
