class Sleep < ApplicationRecord
  validates :started_at, presence: true
  validate :ended_at_comes_after_start

  belongs_to :user

  scope :for_user, ->(user_id) { where(user_id: user_id) }

  scope :list_by_started_at, ->(cursor) do
    ordered = order(started_at: :desc)
    cursor.present? ? ordered.where("started_at < ?", cursor) : ordered
  end

  scope :during_week, ->(time) { where(started_at: time.all_week) }
  scope :followed_by, ->(user_id) do
    joins("JOIN follows ON follows.followed_user_id = sleeps.user_id")
      .where(follows: { user_id: user_id })
  end

  private

  def ended_at_comes_after_start
    if ended_at.present? && ended_at <= started_at
      errors.add(:ended_at, "must be greater than started_at")
    end
  end
end
