class SleepsController < ApplicationController

  def index
    @sleeps = user.sleeps
      .list_by_started_at(list_cursor)
      .limit(list_size)
  end

  def create
    @sleep = user.sleeps.create!(sleep_params)
    render :show, status: :created
  end

  def update
    @sleep = user.sleeps.find(params.fetch(:id))
    @sleep.update!(sleep_params)
    render :show
  end

  private

  def user
    User.find(params.fetch(:user_id))
  end

  def sleep_params
    params.require(:sleep).permit(:started_at, :ended_at)
  end

  def list_size(max: 50)
    params.fetch(:number, max).to_i.clamp(0, max)
  end

  def list_cursor
    params[:from].presence
  end

end
