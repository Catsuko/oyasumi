class SleepsController < ApplicationController

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
    params.require(:sleep).permit(:started_at, :ended_at).transform_values do |v|
      v.present? ? Time.at(v).utc : nil
    end
  end

end
