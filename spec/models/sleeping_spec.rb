# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sleeping do
  let(:user) { User.create!(name: "Test User") }

  describe ".journal" do
    it "returns a Journal instance" do
      journal = described_class.journal(user.id)
      expect(journal).to be_a(Sleeping::Journal)
    end

    it "creates a journal for the specified user" do
      journal = described_class.journal(user.id)
      user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 8.hours)
      sleeps = journal.list_sleeps
      expect(sleeps.count).to eq(1)
    end
  end

  describe ".recorder" do
    it "returns a Recorder instance" do
      recorder = described_class.recorder(user.id)
      expect(recorder).to be_a(Sleeping::Recorder)
    end

    it "creates a recorder for the specified user" do
      recorder = described_class.recorder(user.id)
      sleep = recorder.record(started_at: 1.day.ago, ended_at: 1.day.ago + 8.hours)
      expect(sleep.user_id).to eq(user.id)
    end
  end

  describe ".followed_journals" do
    it "returns a FollowedJournals instance" do
      journal = described_class.followed_journals(user.id)
      expect(journal).to be_a(Sleeping::FollowedJournals)
    end

    it "creates a journal for the specified user's followers" do
      followed_user = User.create!(name: "Followed User")
      user.follow(followed_user)
      followed_user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 8.hours)

      journal = described_class.followed_journals(user.id)
      sleeps = journal.list_sleeps
      expect(sleeps.count).to eq(1)
    end
  end

  describe ".user_profile" do
    it "returns a UserProfile instance" do
      profile = described_class.user_profile(user.id)
      expect(profile).to be_a(Sleeping::UserProfile)
    end

    it "creates a profile for the specified user" do
      profile = described_class.user_profile(user.id)
      expect(profile.id).to eq(user.id)
      expect(profile.name).to eq(user.name)
    end
  end
end
