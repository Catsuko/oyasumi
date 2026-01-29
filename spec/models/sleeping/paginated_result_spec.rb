# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sleeping::PaginatedResult do
  let(:user) { User.create!(name: "Test User") }
  let!(:sleep1) { user.sleeps.create!(started_at: 3.days.ago, ended_at: 3.days.ago + 8.hours) }
  let!(:sleep2) { user.sleeps.create!(started_at: 2.days.ago, ended_at: 2.days.ago + 7.hours) }
  let!(:sleep3) { user.sleeps.create!(started_at: 1.day.ago, ended_at: 1.day.ago + 6.hours) }

  let(:results) { [sleep3, sleep2, sleep1] }
  let(:paginated_result) { described_class.new(results, cursor_field: :started_at) }

  describe "#results" do
    it "returns the array of results" do
      expect(paginated_result.results).to eq(results)
    end
  end

  describe "#next_cursor" do
    context "with results" do
      it "returns the cursor from the last result" do
        expect(paginated_result.next_cursor).to eq(sleep1.started_at.iso8601)
      end

      it "returns an ISO8601 formatted timestamp" do
        expect(paginated_result.next_cursor).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/)
      end
    end

    context "with empty results" do
      let(:results) { [] }

      it "returns nil" do
        expect(paginated_result.next_cursor).to be_nil
      end
    end

    context "with custom cursor field" do
      let(:paginated_result) { described_class.new(results, cursor_field: :created_at) }

      it "uses the specified field for cursor" do
        expect(paginated_result.next_cursor).to eq(sleep1.created_at.iso8601)
      end
    end
  end

  describe "#more_results?" do
    context "with results" do
      it "returns true" do
        expect(paginated_result.more_results?).to be true
      end
    end

    context "with empty results" do
      let(:results) { [] }

      it "returns false" do
        expect(paginated_result.more_results?).to be false
      end
    end
  end

  describe "array delegation" do
    it "delegates #count" do
      expect(paginated_result.count).to eq(3)
    end

    it "delegates #each" do
      expect(paginated_result.map(&:id)).to eq([sleep3.id, sleep2.id, sleep1.id])
    end

    it "delegates #first" do
      expect(paginated_result.first).to eq(sleep3)
    end

    it "delegates #last" do
      expect(paginated_result.last).to eq(sleep1)
    end

    it "delegates #[]" do
      expect(paginated_result[1]).to eq(sleep2)
    end

    it "delegates #to_a" do
      expect(paginated_result.to_a).to eq(results)
    end

    it "delegates #empty?" do
      expect(paginated_result.empty?).to be false
    end
  end
end
