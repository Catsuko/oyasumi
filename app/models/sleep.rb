class Sleep < ApplicationRecord
  validates :ended_at, numericality: { greater_than: :started_at }, allow_nil: true

  belongs_to :user
end
