# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sleeping::Journal do
  let(:user) { User.create!(name: "Test User") }
  let(:other_user) { User.create!(name: "Other User") }
  let(:journal) { described_class.for_user(user.id) }

  describe ".for_user" do
    it "returns a Journal instance" do
      expect(journal).to be_a(described_class)
    end
  end

  describe "#list_sleeps" do
    let!(:sleep1) { user.sleeps.create!(started_at: 3.days.ago, ended_at: 3.days.ago + 8.hours) }
    let!(:sleep2) { user.sleeps.create!(started_at: 2.days.ago, ended_at: 2.days.ago + 7.hours) }
    let!(:sleep3) { user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 6.hours) }
    let!(:other_sleep) { other_user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 5.hours) }

    it "returns user's sleeps ordered by started_at descending" do
      sleeps = journal.list_sleeps
      expect(sleeps.to_a).to eq([sleep3, sleep2, sleep1])
    end

    it "does not return other users' sleeps" do
      sleeps = journal.list_sleeps
      expect(sleeps.to_a).not_to include(other_sleep)
    end

    it "respects the limit parameter" do
      sleeps = journal.list_sleeps(limit: 2)
      expect(sleeps.count).to eq(2)
    end

    context "with cursor pagination" do
      it "returns sleeps after the cursor" do
        cursor = sleep3.started_at
        sleeps = journal.list_sleeps(cursor: cursor)
        expect(sleeps.to_a).to eq([sleep2, sleep1])
      end

      it "returns empty when cursor is before all sleeps" do
        cursor = 4.days.ago
        sleeps = journal.list_sleeps(cursor: cursor)
        expect(sleeps.to_a).to be_empty
      end
    end
  end

  describe "#sleeps_during_week" do
    let(:this_week_time) { Time.zone.now }
    let(:last_week_time) { 1.week.ago }

    let!(:this_week_sleep) { user.sleeps.create!(started_at: this_week_time.beginning_of_week, ended_at: this_week_time.beginning_of_week + 8.hours) }
    let!(:last_week_sleep) { user.sleeps.create!(started_at: last_week_time.beginning_of_week, ended_at: last_week_time.beginning_of_week + 7.hours) }

    it "returns sleeps for the specified week" do
      sleeps = journal.sleeps_during_week(this_week_time)
      expect(sleeps.to_a).to include(this_week_sleep)
      expect(sleeps.to_a).not_to include(last_week_sleep)
    end

    it "respects the limit parameter" do
      sleeps = journal.sleeps_during_week(this_week_time, limit: 1)
      expect(sleeps.count).to eq(1)
    end
  end

  describe "#find" do
    let!(:user_sleep) { user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 8.hours) }
    let!(:other_sleep) { other_user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 7.hours) }

    it "finds the user's sleep by id" do
      sleep = journal.find(user_sleep.id)
      expect(sleep).to eq(user_sleep)
    end

    it "raises error when trying to access another user's sleep" do
      expect { journal.find(other_sleep.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises error when sleep doesn't exist" do
      expect { journal.find(99999) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
