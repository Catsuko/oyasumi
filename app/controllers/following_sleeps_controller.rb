class FollowingSleepsController < ApplicationController

  # TODO: Consider fan-out table or cache for better performance especially with lots of followers.
  # TODO: Drop user obhect from response and replace with `sleep.user_id` and an endpoint for user lookup
  # TODO: Add previous\next week metadata if clients need to scroll through the weeks
  # TODO: Allow clients to paginate by duration to see lower duration sleeps for the given week
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

  # TODO: Refactor into concern for pagination parameters
  def list_size(max: 50)
    params.fetch(:number, max).to_i.clamp(0, max)
  end

  def week_time
    params.key?(:week) ? Time.parse(params.fetch(:week)) : Time.zone.now
  end

end
