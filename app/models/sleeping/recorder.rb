# frozen_string_literal: true

module Sleeping
  # Recorder handles creating and updating sleep records for a user.
  # Provides write operations separate from the read-only journal classes.
  # This maintains consistency where journals are for querying and recorders are for modifying.
  class Recorder
    # Factory method to create a sleep recorder for a user
    # @param user_id [Integer] the user's ID
    # @return [Recorder] a new recorder instance
    def self.for_user(user_id)
      new(user_id)
    end

    def initialize(user_id)
      @user_id = user_id
    end

    # Records a new sleep entry
    #
    # @param params [Hash] sleep attributes
    # @option params [Time, String] :started_at (required) when the sleep started
    # @option params [Time, String, nil] :ended_at (optional) when the sleep ended
    #
    # @return [Sleep] the created sleep record
    #
    # @raise [ActiveRecord::RecordInvalid] if validation fails
    #   - started_at must be present
    #   - ended_at must be after started_at (if provided)
    #
    # @example Record a completed sleep
    #   recorder.record(
    #     started_at: Time.zone.parse("2024-01-29 22:00:00"),
    #     ended_at: Time.zone.parse("2024-01-30 06:00:00")
    #   )
    #
    # @example Record an ongoing sleep
    #   recorder.record(started_at: 1.hour.ago)
    def record(params)
      ::Sleep.for_user(@user_id).create!(params).reload
    end

    # Updates an existing sleep record
    #
    # @param id [Integer] the sleep ID
    # @param params [Hash] sleep attributes to update
    # @option params [Time, String] :started_at (optional) when the sleep started
    # @option params [Time, String, nil] :ended_at (optional) when the sleep ended
    #
    # @return [Sleep] the updated sleep record
    #
    # @raise [ActiveRecord::RecordNotFound] if sleep not found or doesn't belong to user
    # @raise [ActiveRecord::RecordInvalid] if validation fails
    #   - ended_at must be after started_at (if both present)
    #
    # @example End an ongoing sleep
    #   recorder.update(sleep_id, ended_at: Time.zone.now)
    #
    # @example Adjust sleep times
    #   recorder.update(
    #     sleep_id,
    #     started_at: Time.zone.parse("2024-01-29 22:30:00"),
    #     ended_at: Time.zone.parse("2024-01-30 06:30:00")
    #   )
    def update(id, params)
      sleep = ::Sleep.for_user(@user_id).find(id)
      sleep.update!(params)
      sleep.reload
    end
  end
end
