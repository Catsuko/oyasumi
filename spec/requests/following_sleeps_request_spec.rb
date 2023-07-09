require "rails_helper"

RSpec.describe "Following Sleeps Requests" do
  let(:user) { User.create!(name: "Cat") }

  describe "GET /users/:user_id/following_sleeps" do
    let!(:other_user) { User.create!(name: "Dog") }
    let!(:other_user_sleeps) do
      3.times.map { |n| other_user.sleeps.create!(started_at: (n+1).hours.ago, ended_at: Time.current) }
    end
    let!(:index_params) { {} }
    let!(:previous_week_sleep) do
      other_user.sleeps.create!(started_at: 8.days.ago, ended_at: 7.days.ago)
    end
    subject { get(user_following_sleeps_path(user_id: user.id, **index_params), as: :json) }

    it "responds with success" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "responds with empty array when the user is not following anyone" do
      subject
      expect(json_response).to match hash_including("data" => [])
    end

    context "when following a user" do
      before { user.follow(other_user) }

      it "responds with sleeps from the current week" do
        expected_details = other_user_sleeps.map do |sleep|
          hash_including(
            "id"         => sleep.id,
            "started_at" => sleep.started_at.as_json,
            "ended_at"   => sleep.ended_at.as_json,
            "user"       => hash_including(
              "name" => other_user.name
            )
          )
        end
        subject
        expect(json_response.fetch("data")).to match_array expected_details
      end

      it "can use the `week` parameter to retrieve sleeps from the previous week" do
        index_params.merge!(week: previous_week_sleep.started_at.as_json)
        subject
        expect(json_response.fetch("data")).to contain_exactly(hash_including("id" => previous_week_sleep.id))
      end

      it "is ordered by duration" do
        index_params.merge!(number: 1)
        subject
        expect(json_response.fetch("data")).to contain_exactly(hash_including("id" => other_user_sleeps.last.id))
      end
    end
  end
end
