require "rails_helper"

RSpec.describe "Sleeps Requests" do
  let(:user) { User.create!(name: "Snorlax") }

  describe "POST /users/:user_id/sleeps" do
    let(:started_at) { Time.current }
    let(:create_params) { { started_at: started_at.to_i } }
    subject { post(user_sleeps_path(user_id: user.id), params: { sleep: create_params }, as: :json) }

    it "responds with success" do
      subject
      expect(response).to have_http_status(:created)
    end

    it "creates a new sleep record" do
      expect { subject }.to change(user.sleeps, :count).by(1)
    end

    it "responds with the created sleep details" do
      subject
      expect(json_response).to match hash_including(
        "data" => hash_including(
          "started_at" => started_at.to_i,
          "ended_at"   => nil
        )
      )
    end

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
      before { create_params.merge!(ended_at: ended_at.to_i) }

      it "responds with the ended_at timestamp" do
        subject
        expect(json_response).to match hash_including(
          "data" => hash_including(
            "started_at" => started_at.to_i,
            "ended_at"   => ended_at.to_i
          )
        )
      end
    end
  end
end
