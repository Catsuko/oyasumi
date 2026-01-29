# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sleeping::UserProfile do
  let(:user) { User.create!(name: "Main User") }
  let(:other_user) { User.create!(name: "Other User") }
  let(:profile) { described_class.find(user.id) }

  describe ".find" do
    it "returns a UserProfile instance" do
      expect(profile).to be_a(described_class)
    end

    it "sets the id attribute" do
      expect(profile.id).to eq(user.id)
    end

    it "raises error when accessing nonexistent user's methods" do
      invalid_profile = described_class.find(99999)
      expect { invalid_profile.name }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#follow" do
    it "makes the user follow the other user" do
      expect { profile.follow(other_user.id) }.to change { user.following?(other_user) }.from(false).to(true)
    end

    it "has no effect if already following" do
      profile.follow(other_user.id)
      expect { profile.follow(other_user.id) }.not_to change(Follow, :count)
    end

    it "raises error when following themselves" do
      expect { profile.follow(user.id) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "raises error when other user doesn't exist" do
      expect { profile.follow(99999) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#unfollow" do
    before do
      user.follow(other_user)
    end

    it "makes the user unfollow the other user" do
      expect { profile.unfollow(other_user.id) }.to change { user.following?(other_user) }.from(true).to(false)
    end

    it "has no effect if not following" do
      profile.unfollow(other_user.id)
      expect { profile.unfollow(other_user.id) }.not_to raise_error
    end

    it "raises error when other user doesn't exist" do
      expect { profile.unfollow(99999) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#following?" do
    context "when following the other user" do
      before do
        user.follow(other_user)
      end

      it "returns true" do
        expect(profile.following?(other_user.id)).to be true
      end
    end

    context "when not following the other user" do
      it "returns false" do
        expect(profile.following?(other_user.id)).to be false
      end
    end

    it "raises error when other user doesn't exist" do
      expect { profile.following?(99999) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#name" do
    it "returns the user's name" do
      expect(profile.name).to eq(user.name)
    end
  end
end
