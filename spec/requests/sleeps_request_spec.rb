require "rails_helper"

RSpec.describe "Sleeps Requests" do
  let(:user) { User.create!(name: "Snorlax") }

  shared_examples "sleep response" do
    it "response includes sleep details" do
      subject
      expect(json_response).to match hash_including(
        "data" => hash_including(
          "id"         => kind_of(Integer),
          "started_at" => started_at.as_json,
          "ended_at"   => ended_at&.as_json
        )
      )
    end
  end

  describe "POST /users/:user_id/sleeps" do
    let(:started_at) { Time.zone.now }
    let(:ended_at) { nil }
    let(:create_params) { { started_at: started_at.as_json } }
    subject { post(user_sleeps_path(user_id: user.id), params: { sleep: create_params }, as: :json) }

    it "responds with success" do
      subject
      expect(response).to have_http_status(:created)
    end

    it "creates a new sleep record" do
      expect { subject }.to change(user.sleeps, :count).by(1)
    end

    it_behaves_like "sleep response"

    context "when started_at is not provided" do
      let(:create_params) { { started_at: nil } }

      it "responds with error" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a sleep record" do
        expect { subject }.not_to change(user.sleeps, :count)
      end
    end

    context "when ended_at is provided" do
      let(:ended_at) { 1.hour.from_now }
      before { create_params.merge!(ended_at: ended_at.as_json) }

      it_behaves_like "sleep response"
    end
  end

  describe "PUT /users/:user_id/sleeps/:id" do
    let(:started_at) { 1.hour.ago }
    let(:ended_at) { Time.zone.now.change(usec: 0) }
    let(:sleep) { user.sleeps.create!(started_at: started_at) }
    let(:update_params) { { ended_at: ended_at.as_json } }
    subject { put(user_sleep_path(user_id: user.id, id: sleep.id), params: { sleep: update_params }, as: :json) }

    it "responds with success" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "updates the provided sleep record" do
      expect { subject }.to change { sleep.reload.ended_at }.from(nil).to(ended_at)
    end

    it_behaves_like "sleep response"
  end

  describe "GET /users/:user_id/sleeps" do
    let!(:sleeps) do
      3.times.map { |n| user.sleeps.create!(started_at: (n + 1).hours.ago, ended_at: Time.zone.now) }
    end
    let(:index_params) { {} }
    subject { get(user_sleeps_path(user_id: user.id, **index_params), as: :json) }

    it "responds with success" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "response lists sleep details" do
      expected_details = sleeps.map do |sleep|
        hash_including(
          "id"         => sleep.id,
          "started_at" => sleep.started_at.as_json,
          "ended_at"   => sleep.ended_at.as_json
        )
      end
      subject
      expect(json_response.fetch("data")).to match_array expected_details
    end

    it "is ordered by started_at time in descending order" do
      subject
      expect(json_response.fetch("data").pluck("id")).to match(
        user.sleeps.order(started_at: :desc).pluck(:id)
      )
    end

    it "does not include sleeps logged by other users" do
      other_user = User.create!(name: "Guldan")
      other_user_sleep = other_user.sleeps.create!(started_at: Time.zone.now)
      subject
      expect(json_response.fetch("data").pluck("id")).not_to include(other_user_sleep.id)
    end

    it "can limit the number of results with the `number` parameter" do
      index_params.merge!(number: 1)
      subject
      expect(json_response.fetch("data")).to contain_exactly(
        hash_including("id" => sleeps.first.id)
      )
    end
  end
end
