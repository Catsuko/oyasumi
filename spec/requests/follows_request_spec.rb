require "rails_helper"

RSpec.describe "Follows Requests" do
  let(:user) { User.create!(name: "Kat") }
  let(:followed_user) { User.create!(name: "Ana") }

  describe "follow user" do
    subject { post(user_follows_path(user_id: user.id), params: { followed_user_id: followed_user.id }) }

    it "responds with success" do
      subject
      expect(response).to have_http_status(:no_content)
    end

    it "follows the provided user" do
      expect { subject }.to change { user.following?(followed_user) }.from(false).to(true)
    end
  end
end
