require "rails_helper"

RSpec.describe User do

  let(:user) { described_class.create!(name: "Blossom") }
  let(:other_user) { described_class.create!(name: "Buttercup") }

  describe "#follow" do
    subject { user.follow(other_user) }

    it "follows the other user" do
      expect { subject }.to change { user.following?(other_user) }.from(false).to(true)
    end

    it "has no effect if the user is already following the other user" do
      subject
      expect { subject }.not_to change(Follow, :count)
    end

    context "following themselves" do
      let(:other_user) { user }

      it "raises an error" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#unfollow" do
    subject { user.unfollow(other_user) }

    it "stops following the other user" do
      user.follow(other_user)
      expect { subject }.to change { user.following?(other_user) }.from(true).to(false)
    end

    it "has no effect if the user is not following the other user" do
      expect { subject }.not_to raise_error
    end

  end

end
