class FollowingSleepsController < ApplicationController

  def index
    @sleeps = Sleep.includes(:user)
      .during_week(week_time)
      .followed_by(user)
      .order(duration: :desc)
      .limit(list_size)
  end

  private

  def user
    User.find(params.fetch(:user_id))
  end

  def list_size(max: 50)
    params.fetch(:number, max).to_i.clamp(0, max)
  end

  def week_time
    params.key?(:week) ? Time.parse(params.fetch(:week)) : Time.zone.now
  end

end
