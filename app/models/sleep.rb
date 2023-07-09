class Sleep < ApplicationRecord
  validates :started_at, presence: true
  validate :ended_at_comes_after_start

  belongs_to :user

  scope :list_by_started_at, ->(cursor) do
    ordered = order(started_at: :desc)
    cursor.present? ? ordered.where("started_at < ?", cursor) : ordered
  end

  private

  def ended_at_comes_after_start
    if ended_at.present? && ended_at <= started_at
      errors.add(:ended_at, "must be greater than started_at")
    end
  end
end
