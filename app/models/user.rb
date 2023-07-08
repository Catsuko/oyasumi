class User < ApplicationRecord
  validates :name, presence: true

  has_many :follows

  def follow(user)
    follows.create!(followed_user: user)
  rescue ActiveRecord::RecordNotUnique
  end

  def unfollow(user)
    follows.where(followed_user: user).delete_all
  end

  def following?(user)
    follows.where(followed_user: user).exists?
  end
end
