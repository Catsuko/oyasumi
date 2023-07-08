require "rails_helper"

RSpec.describe "Follows Requests" do
  let(:user) { User.create!(name: "Kat") }
  let(:followed_user) { User.create!(name: "Ana") }

  shared_examples "missing users are handled" do
    it "responds with error when user is missing" do
      user.destroy
      subject
      expect(response).to have_http_status(:not_found)
    end

    it "responds with error when followed user is missing" do
      followed_user.destroy
      subject
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /users/:user_id/follows" do
    subject { post(user_follows_path(user_id: user.id), params: { followed_user_id: followed_user.id }) }

    it "responds with success" do
      subject
      expect(response).to have_http_status(:no_content)
    end

    it "follows the provided user" do
      expect { subject }.to change { user.following?(followed_user) }.from(false).to(true)
    end

    it_behaves_like "missing users are handled"
  end

  describe "DELETE /users/:user_id/follows/:followed_user_id" do
    subject { delete(user_follow_path(user_id: user.id, followed_user_id: followed_user.id)) }

    it "responds with success" do
      subject
      expect(response).to have_http_status(:no_content)
    end

    it "unfollows the provided user" do
      user.follow(followed_user)
      expect { subject }.to change { user.following?(followed_user) }.from(true).to(false)
    end

    it_behaves_like "missing users are handled"
  end
end
