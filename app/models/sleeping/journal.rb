# frozen_string_literal: true

module Sleeping
  # Journal represents a single user's sleep journal (read-only).
  # Provides methods for querying and viewing sleeps for a user.
  # For creating or updating sleeps, use SleepRecorder instead.
  # Encapsulates the Sleep ActiveRecord model to enforce package boundaries.
  class Journal
    # Factory method to create a sleep journal for a user
    # @param user_id [Integer] the user's ID
    # @return [Journal] a new journal instance
    def self.for_user(user_id)
      new(user_id)
    end

    def initialize(user_id)
      @user_id = user_id
    end

    # Lists sleeps with cursor-based pagination
    # @param cursor [String, nil] optional cursor for pagination (started_at timestamp)
    # @param limit [Integer] maximum number of results (default: 50)
    # @return [PaginatedResult] results with next_cursor for pagination
    def list_sleeps(cursor: nil, limit: 50)
      results = sleeps_scope.list_by_started_at(cursor).limit(limit)
      PaginatedResult.new(results, cursor_field: :started_at)
    end

    # Lists sleeps during a specific week
    # @param time [Time] time within the target week
    # @param limit [Integer] maximum number of results (default: 50)
    # @return [ActiveRecord::Relation] scope of Sleep records
    def sleeps_during_week(time, limit: 50)
      sleeps_scope.during_week(time).limit(limit)
    end

    # Finds a specific sleep by ID
    # @param id [Integer] the sleep ID
    # @return [Sleep] the sleep record
    # @raise [ActiveRecord::RecordNotFound] if sleep not found or doesn't belong to user
    def find(id)
      sleeps_scope.find(id)
    end

    private

    # Returns the scope for this user's sleeps
    # @return [ActiveRecord::Relation]
    def sleeps_scope
      ::Sleep.for_user(@user_id)
    end
  end
end
