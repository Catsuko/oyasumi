class Follow < ApplicationRecord
  validates :followed_user, comparison: { other_than: :user }

  belongs_to :user
  belongs_to :followed_user, class_name: "User"
end
