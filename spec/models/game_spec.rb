require 'rails_helper'

RSpec.describe Game, type: :model do
  subject(:game) { build(:game) }

  describe "validations" do
    it { is_expected.to be_valid }

    it "is invalid without an owner name" do
      game.owner_name = nil
      expect(subject).not_to be_valid
    end
  end

  # Associations
  describe "associations" do
    it { is_expected.to respond_to(:players) }
    it { is_expected.to respond_to(:rounds) }

    context "when destroying a game" do
      before do
        create(:player, game: game_with_player)
        create(:round, game: game_with_round)
      end

      let!(:game_with_player) { create(:game) }
      let!(:game_with_round) { create(:game) }

      it "destroys dependent players when game is destroyed" do
        expect { game_with_player.destroy }.to change { Player.count }.by(-1)
      end

      it "destroys dependent rounds when game is destroyed" do
        expect { game_with_round.destroy }.to change { Round.count }.by(-1)
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
    let(:round_without_title) { game_for_round.start_new_round }

    it "creates a new round for the game" do
      expect { subject }.to change { game_for_round.rounds.count }.by(1)
    end

    it "allows setting a story title for the new round" do
      expect(subject.story_title).to eq("Test Story")
    end
  end

  describe "#voting_in_progress?" do
    subject(:voting_in_progress) { game_for_voting.voting_in_progress? }

    let(:game_for_voting) { create(:game) }

    context "when current round is in voting" do
      let!(:round) { create(:round, game: game_for_voting, status: :in_progress) }

      it { expect(voting_in_progress).to be_truthy }
    end

    context "when current round is finished" do
      let!(:round) { create(:round, game: game_for_voting, status: :finished) }

      it { expect(voting_in_progress).to be_falsey }
    end

    context "when no rounds exist" do
      it { expect(voting_in_progress).to be_falsey }
    end
  end
end
