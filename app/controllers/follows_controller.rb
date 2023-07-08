class FollowsController < ApplicationController

  def create
    user = User.find(params.fetch(:user_id))
    user_to_follow = User.find(params.fetch(:followed_user_id))

    user.follow(user_to_follow)
    head :no_content
  end

end
