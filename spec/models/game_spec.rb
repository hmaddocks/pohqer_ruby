require 'rails_helper'

RSpec.describe Game, type: :model do
  # Include FactoryBot methods
  include FactoryBot::Syntax::Methods

  # Subject for the Game model
  subject(:game) { build(:game) }

  # Validations
  describe "validations" do
    it { is_expected.to be_valid }

    it "is invalid without an owner name" do
      game.owner_name = nil
      is_expected.not_to be_valid
    end
  end

  # Associations
  describe "associations" do
    # it { is_expected.to have_many(:players) }
    # it { is_expected.to have_many(:rounds) }
    it { is_expected.to respond_to(:players) }
    it { is_expected.to respond_to(:rounds) }

    context "when destroying a game" do
      let!(:game_with_player) { create(:game) }
      let!(:player) { create(:player, game: game_with_player) }
      let!(:game_with_round) { create(:game) }
      let!(:round) { create(:round, game: game_with_round) }

      it "destroys dependent players when game is destroyed" do
        expect { game_with_player.destroy }.to change { Player.count }.by(-1)
      end

      it "destroys dependent rounds when game is destroyed" do
        expect { game_with_round.destroy }.to change { Round.count }.by(-1)
      end
    end
  end

  # Instance methods
  describe "#current_round" do
    let(:game_with_rounds) { create(:game) }

    context "with multiple rounds" do
      let!(:round1) { create(:round, game: game_with_rounds) }
      let!(:round2) { create(:round, game: game_with_rounds) }

      it "returns the last round of the game" do
        expect(game_with_rounds.current_round).to eq(round2)
      end
    end

    context "with no rounds" do
      it "returns nil" do
        expect(game_with_rounds.current_round).to be_nil
      end
    end
  end

  describe "#start_new_round" do
    let(:game_for_round) { create(:game) }
    let(:round) { game_for_round.start_new_round(story_title: "Test Story") }
    let(:round_without_title) { game_for_round.start_new_round }

    it "creates a new round for the game" do
      expect { game_for_round.start_new_round }.to change { game_for_round.rounds.count }.by(1)
    end

    it "allows setting a story title for the new round" do
      expect(round.story_title).to eq("Test Story")
    end

    it "returns the newly created round" do
      expect(round_without_title).to be_a(Round)
      expect(round_without_title).to be_persisted
    end
  end

  describe "#voting_in_progress?" do
    let(:game_for_voting) { create(:game) }

    context "when current round is in voting" do
      let!(:round) { create(:round, game: game_for_voting, finished: false) }

      it { expect(game_for_voting.voting_in_progress?).to be_truthy }
    end

    context "when current round is finished" do
      let!(:round) { create(:round, game: game_for_voting, finished: true) }

      it { expect(game_for_voting.voting_in_progress?).to be_falsey }
    end

    context "when no rounds exist" do
      it { expect(game_for_voting.voting_in_progress?).to be_falsey }
    end
  end
end
