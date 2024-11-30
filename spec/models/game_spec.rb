# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "validations" do
    subject { build(:game, owner_name:) }

    context "when owner name is present" do
      let(:owner_name) { "Jane" }

      it { is_expected.to be_valid }
    end

    context "when owner name is missing" do
      let(:owner_name) { nil }

      it "is invalid without an owner name" do
        expect(subject).not_to be_valid
      end
    end
  end

  describe "#current_round" do
    subject { game_with_rounds.current_round }

    let(:game_with_rounds) { create(:game) }

    context "with multiple rounds" do
      before do
        create(:round, game: game_with_rounds)
      end

      let!(:round2) { create(:round, game: game_with_rounds) }

      it "returns the last round of the game" do
        expect(subject).to eq(round2)
      end
    end

    context "with no rounds" do
      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end

  describe "#start_new_round" do
    subject { game_for_round.start_new_round(story_title: "Test Story") }

    let(:game_for_round) { create(:game) }

    it "creates a new round for the game" do
      expect { subject }.to change { game_for_round.rounds.count }.by(1)
    end

    it "allows setting a story title for the new round" do
      expect(subject.story_title).to eq("Test Story")
    end
  end
end
