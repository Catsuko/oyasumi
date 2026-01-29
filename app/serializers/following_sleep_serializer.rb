class FollowingSleepSerializer
  def initialize(sleep)
    @sleep = sleep
  end

  def as_json(*)
    SleepSerializer.new(@sleep).as_json.merge!(
      user: UserSerializer.new(@sleep.user).as_json
    )
  end
end
