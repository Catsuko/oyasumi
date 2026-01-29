class SleepsController < ApplicationController

  def index
    @sleeps = sleep_journal.list_sleeps(cursor: list_cursor, limit: list_size)
    render json: ResponseSerializer.new(@sleeps, serializer: SleepSerializer)
  end

  def create
    @sleep = sleep_recorder.record(sleep_params)
    render json: ResponseSerializer.new(@sleep, serializer: SleepSerializer), status: :created
  end

  def update
    @sleep = sleep_recorder.update(params.fetch(:id), sleep_params)
    render json: ResponseSerializer.new(@sleep, serializer: SleepSerializer)
  end

  private

  def sleep_journal
    Sleeping.journal(params.fetch(:user_id))
  end

  def sleep_recorder
    Sleeping.recorder(params.fetch(:user_id))
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
