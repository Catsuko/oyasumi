# frozen_string_literal: true

module Sleeping
  # FollowedJournals is a composite journal that aggregates sleeps
  # from all users that the given user follows.
  # Implements the same interface as SleepJournal for polymorphic usage.
  # Encapsulates the Sleep ActiveRecord model to enforce package boundaries.
  class FollowedJournals
    # Factory method to create a followers' sleep journal for a user
    # @param user_id [Integer] the user's ID
    # @return [FollowedJournals] a new journal instance
    def self.for_user(user_id)
      new(user_id)
    end

    def initialize(user_id)
      @user_id = user_id
    end

    # Lists sleeps from followed users with cursor-based pagination
    # @param cursor [String, nil] optional cursor for pagination (started_at timestamp)
    # @param limit [Integer] maximum number of results (default: 50)
    # @return [PaginatedResult] results with next_cursor for pagination
    def list_sleeps(cursor: nil, limit: 50)
      results = sleeps_scope.list_by_started_at(cursor).limit(limit)
      PaginatedResult.new(results, cursor_field: :started_at)
    end

    # Lists sleeps from followed users during a specific week, ordered by duration
    # @param time [Time] time within the target week
    # @param limit [Integer] maximum number of results (default: 50)
    # @return [ActiveRecord::Relation] scope of Sleep records ordered by duration descending
    def sleeps_during_week(time, limit: 50)
      ::Sleep.includes(:user)
        .during_week(time)
        .followed_by(@user_id)
        .order(duration: :desc)
        .limit(limit)
    end

    private

    # Returns the scope for followed users' sleeps
    # @return [ActiveRecord::Relation]
    def sleeps_scope
      ::Sleep.followed_by(@user_id)
    end
  end
end
