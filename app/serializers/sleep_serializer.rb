class SleepSerializer
  def initialize(sleep)
    @sleep = sleep
  end

  def as_json(*)
    {
      id: @sleep.id,
      started_at: @sleep.started_at,
      ended_at: @sleep.ended_at,
      duration: @sleep.duration&.to_i
    }
  end
end
