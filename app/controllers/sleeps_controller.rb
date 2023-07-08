class SleepsController < ApplicationController

  def create
    @sleep = user.sleeps.create!(create_params)
    render :show, status: :created
  end

  private

  def user
    User.find(params.fetch(:user_id))
  end

  def create_params
    params.require(:sleep).permit(:started_at, :ended_at).transform_values do |v|
      v.present? ? Time.at(v).utc : nil
    end
  end

end
