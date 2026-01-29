# pack_public: true
# frozen_string_literal: true

# Sleeping domain module - public interface for sleep tracking functionality.
# This module provides factory methods for creating domain objects
# that encapsulate Active Record models and enforce package boundaries.
module Sleeping
  # Factory method to create a sleep journal for a user
  # @param user_id [Integer] the user's ID
  # @return [Journal] a journal instance
  def self.journal(user_id)
    Journal.for_user(user_id)
  end

  # Factory method to create a followed journals aggregator for a user
  # @param user_id [Integer] the user's ID
  # @return [FollowedJournals] a composite journal instance
  def self.followed_journals(user_id)
    FollowedJournals.for_user(user_id)
  end

  # Factory method to create a sleep recorder for a user
  # @param user_id [Integer] the user's ID
  # @return [Recorder] a recorder instance
  def self.recorder(user_id)
    Recorder.for_user(user_id)
  end

  # Factory method to get a user profile
  # @param user_id [Integer] the user's ID
  # @return [UserProfile] a user profile instance
  def self.user_profile(user_id)
    UserProfile.find(user_id)
  end
end
