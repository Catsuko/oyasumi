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

  describe '.followed_by' do
    let(:followed_user) { User.create!(name: "Nyx") }
    let(:unknown_user) { User.create!(name: "Pugna") }
    let!(:followed_sleep) { followed_user.sleeps.create!(started_at: 3.hours.ago, ended_at: 1.hour.ago) }
    let!(:unknown_sleep) { unknown_user.sleeps.create!(started_at: 1.hour.ago, ended_at: 5.minutes.ago) }

    subject { described_class.followed_by(user) }

    before do
      user.follows.create!(followed_user: followed_user)
    end

    it 'contains only sleeps from users followed by the provided user' do
      is_expected.to contain_exactly(followed_sleep)
    end
  end

  describe '.during_week' do
    let(:time) { Time.current }
    let(:during_week_sleep) { user.sleeps.create!(started_at: 5.minutes.ago) }
    let(:irrelevant_sleep) { user.sleeps.create!(started_at: 1.year.ago) }

    subject { described_class.during_week(time) }

    it 'contains only sleeps from the week of the provided time' do
      is_expected.to contain_exactly(during_week_sleep)
    end
  end

end
