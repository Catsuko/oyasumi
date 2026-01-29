class FollowsController < ApplicationController

  def create
    user_profile.follow(params.fetch(:followed_user_id))
    head :no_content
  end

  def destroy
    user_profile.unfollow(params.fetch(:followed_user_id))
    head :no_content
  end

  private

  def user_profile
    Sleeping.user_profile(params.fetch(:user_id))
  end

end
