# frozen_string_literal: true

module Sleeping
  # UserProfile represents a user's social profile.
  # Provides methods for following/unfollowing users and checking follow status.
  # Encapsulates the User ActiveRecord model to enforce package boundaries.
  class UserProfile
    attr_reader :id

    # Factory method to find a user profile by ID
    # @param user_id [Integer] the user's ID
    # @return [UserProfile] a new profile instance
    def self.find(user_id)
      new(user_id)
    end

    def initialize(user_id)
      @user_id = user_id
      @id = user_id
    end

    # Follow another user
    # @param other_user_id [Integer] the ID of the user to follow
    # @return [void]
    def follow(other_user_id)
      other_user = ::User.find(other_user_id)
      user.follow(other_user)
    end

    # Unfollow another user
    # @param other_user_id [Integer] the ID of the user to unfollow
    # @return [void]
    def unfollow(other_user_id)
      other_user = ::User.find(other_user_id)
      user.unfollow(other_user)
    end

    # Check if this user is following another user
    # @param other_user_id [Integer] the ID of the user to check
    # @return [Boolean] true if following, false otherwise
    def following?(other_user_id)
      other_user = ::User.find(other_user_id)
      user.following?(other_user)
    end

    # Expose the user's name
    # @return [String] the user's name
    def name
      user.name
    end

    private

    # Returns the user instance
    # @return [User]
    def user
      @user ||= ::User.find(@user_id)
    end
  end
end
