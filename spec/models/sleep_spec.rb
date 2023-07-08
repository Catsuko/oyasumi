require "rails_helper"

RSpec.describe Sleep do
  let(:user) { User.create!(name: "Pango") }

  describe "#ended_at" do
    it "can be nil" do
      expect(user.sleeps.create!(started_at: Time.current)).to be_valid
    end

    it "can be after started_at" do
      expect(user.sleeps.create!(started_at: 1.year.ago, ended_at: Time.current)).to be_valid
    end

    it "cannot be before started_at" do
      expect { user.sleeps.create!(started_at: Time.current, ended_at: 1.hour.ago) }.to raise_error(
        ActiveRecord::RecordInvalid
      )
    end
  end

  describe "#duration" do
    let(:started_at) { 2.hours.ago }
    let(:ended_at) { 1.hour.since(started_at) }
    let(:sleep) { user.sleeps.create!(started_at: started_at, ended_at: ended_at).reload }

    subject { sleep.duration }

    it "equals the duration between start and end times" do
      is_expected.to eq ended_at - started_at      
    end

    context "when the sleep has not yet ended" do
      let(:ended_at) { nil }

      it "duration is not set" do
        is_expected.to be_nil
      end
    end
  end

end
