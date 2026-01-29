# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sleeping::Recorder do
  let(:user) { User.create!(name: "Test User") }
  let(:other_user) { User.create!(name: "Other User") }
  let(:recorder) { described_class.for_user(user.id) }

  describe ".for_user" do
    it "returns a Recorder instance" do
      expect(recorder).to be_a(described_class)
    end
  end

  describe "#record" do
    let(:params) { { started_at: 1.day.ago, ended_at: 1.day.ago + 8.hours } }

    it "creates a new sleep for the user" do
      expect { recorder.record(params) }.to change { user.sleeps.count }.by(1)
    end

    it "returns the created sleep" do
      sleep = recorder.record(params)
      expect(sleep).to be_a(Sleep)
      expect(sleep.user_id).to eq(user.id)
    end

    it "raises error with invalid params" do
      invalid_params = { started_at: nil }
      expect { recorder.record(invalid_params) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "populates computed duration column without reload" do
      sleep = recorder.record(params)
      expect(sleep.duration).not_to be_nil
      expect(sleep.duration).to be_a(ActiveSupport::Duration)
    end
  end

  describe "#update" do
    let!(:user_sleep) { user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 8.hours) }
    let!(:other_sleep) { other_user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 7.hours) }
    let(:update_params) { { ended_at: 1.day.ago + 9.hours } }

    it "updates the user's sleep" do
      updated = recorder.update(user_sleep.id, update_params)
      expect(updated.ended_at).to eq(update_params[:ended_at])
    end

    it "returns the updated sleep" do
      updated = recorder.update(user_sleep.id, update_params)
      expect(updated).to be_a(Sleep)
      expect(updated.id).to eq(user_sleep.id)
    end

    it "raises error when trying to update another user's sleep" do
      expect { recorder.update(other_sleep.id, update_params) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises error with invalid params" do
      invalid_params = { ended_at: 2.days.ago }
      expect { recorder.update(user_sleep.id, invalid_params) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "updates computed duration column without reload" do
      updated = recorder.update(user_sleep.id, update_params)
      expect(updated.duration).not_to be_nil
      expect(updated.duration).to be_a(ActiveSupport::Duration)
    end
  end
end
