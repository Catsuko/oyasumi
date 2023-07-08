class FollowsController < ApplicationController

  def create
    user.follow(followed_user)
    head :no_content
  end

  def destroy
    user.unfollow(followed_user)
    head :no_content
  end

  private

  def user
    User.find(params.fetch(:user_id))
  end

  def followed_user
    User.find(params.fetch(:followed_user_id))
  end

end
