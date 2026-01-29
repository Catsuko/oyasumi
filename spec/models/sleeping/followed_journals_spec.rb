# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sleeping::FollowedJournals do
  let(:user) { User.create!(name: "Main User") }
  let(:followed_user1) { User.create!(name: "Followed User 1") }
  let(:followed_user2) { User.create!(name: "Followed User 2") }
  let(:non_followed_user) { User.create!(name: "Non Followed User") }
  let(:journal) { described_class.for_user(user.id) }

  before do
    user.follow(followed_user1)
    user.follow(followed_user2)
  end

  describe ".for_user" do
    it "returns a FollowedJournals instance" do
      expect(journal).to be_a(described_class)
    end
  end

  describe "#list_sleeps" do
    let!(:followed_sleep1) { followed_user1.sleeps.create!(started_at: 2.days.ago, ended_at: 2.days.ago + 8.hours) }
    let!(:followed_sleep2) { followed_user2.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 7.hours) }
    let!(:non_followed_sleep) { non_followed_user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 6.hours) }
    let!(:user_own_sleep) { user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 5.hours) }

    it "returns sleeps from followed users ordered by started_at descending" do
      sleeps = journal.list_sleeps
      expect(sleeps.to_a).to include(followed_sleep1, followed_sleep2)
    end

    it "does not return non-followed users' sleeps" do
      sleeps = journal.list_sleeps
      expect(sleeps.to_a).not_to include(non_followed_sleep)
    end

    it "does not return the user's own sleeps" do
      sleeps = journal.list_sleeps
      expect(sleeps.to_a).not_to include(user_own_sleep)
    end

    it "respects the limit parameter" do
      sleeps = journal.list_sleeps(limit: 1)
      expect(sleeps.count).to eq(1)
    end

    context "with cursor pagination" do
      it "returns sleeps after the cursor" do
        cursor = followed_sleep2.started_at
        sleeps = journal.list_sleeps(cursor: cursor)
        expect(sleeps.to_a).to eq([followed_sleep1])
      end
    end

    context "when user follows no one" do
      let(:lonely_user) { User.create!(name: "Lonely User") }
      let(:lonely_journal) { described_class.for_user(lonely_user.id) }

      it "returns empty" do
        sleeps = lonely_journal.list_sleeps
        expect(sleeps.to_a).to be_empty
      end
    end
  end

  describe "#sleeps_during_week" do
    let(:this_week_time) { Time.zone.now }
    let(:last_week_time) { 1.week.ago }

    let!(:this_week_sleep) do
      followed_user1.sleeps.create!(
        started_at: this_week_time.beginning_of_week,
        ended_at: this_week_time.beginning_of_week + 8.hours
      )
    end
    let!(:last_week_sleep) do
      followed_user1.sleeps.create!(
        started_at: last_week_time.beginning_of_week,
        ended_at: last_week_time.beginning_of_week + 7.hours
      )
    end

    it "returns followed users' sleeps for the specified week" do
      sleeps = journal.sleeps_during_week(this_week_time)
      expect(sleeps.to_a).to include(this_week_sleep)
      expect(sleeps.to_a).not_to include(last_week_sleep)
    end

    it "orders by duration descending" do
      short_sleep = followed_user1.sleeps.create!(
        started_at: this_week_time.beginning_of_week + 1.day,
        ended_at: this_week_time.beginning_of_week + 1.day + 5.hours
      )
      long_sleep = followed_user2.sleeps.create!(
        started_at: this_week_time.beginning_of_week + 1.day,
        ended_at: this_week_time.beginning_of_week + 1.day + 10.hours
      )

      sleeps = journal.sleeps_during_week(this_week_time)
      expect(sleeps.first).to eq(long_sleep)
    end

    it "respects the limit parameter" do
      sleeps = journal.sleeps_during_week(this_week_time, limit: 1)
      expect(sleeps.count).to eq(1)
    end

    it "includes user association" do
      sleeps = journal.sleeps_during_week(this_week_time)
      expect(sleeps.first.association(:user).loaded?).to be true
    end
  end

end
