require "rails_helper"

RSpec.describe "Sleeps Requests" do
  let(:user) { User.create!(name: "Snorlax") }

  shared_examples "responds with sleep details" do
    it do
      subject
      expect(json_response).to match hash_including(
        "data" => hash_including(
          "id"         => kind_of(Integer),
          "started_at" => started_at.to_i,
          "ended_at"   => ended_at&.to_i
        )
      )
    end
  end

  describe "POST /users/:user_id/sleeps" do
    let(:started_at) { Time.current }
    let(:ended_at) { nil }
    let(:create_params) { { started_at: started_at.to_i } }
    subject { post(user_sleeps_path(user_id: user.id), params: { sleep: create_params }, as: :json) }

    it "responds with success" do
      subject
      expect(response).to have_http_status(:created)
    end

    it "creates a new sleep record" do
      expect { subject }.to change(user.sleeps, :count).by(1)
    end

    it_behaves_like "responds with sleep details"

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

      it_behaves_like "responds with sleep details"
    end
  end

  describe "PUT /users/:user_id/sleeps/:id" do
    let(:started_at) { 1.hour.ago }
    let(:ended_at) { Time.current.change(usec: 0) }
    let(:sleep) { user.sleeps.create!(started_at: started_at) }
    let(:update_params) { { ended_at: ended_at.to_i } }
    subject { put(user_sleep_path(user_id: user.id, id: sleep.id), params: { sleep: update_params }, as: :json) }

    it "responds with success" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "updates the provided sleep record" do
      expect { subject }.to change { sleep.reload.ended_at }.from(nil).to(ended_at)
    end

    it_behaves_like "responds with sleep details"
  end
end
