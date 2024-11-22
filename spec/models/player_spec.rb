require 'rails_helper'

RSpec.describe Player, type: :model do
  # Include FactoryBot methods
  include FactoryBot::Syntax::Methods

  # Subject for the Player model
  subject(:player) { build(:player) }

  # Validations
  describe "validations" do
    it { is_expected.to be_valid }

    it "is invalid without a name" do
      player.name = nil
      is_expected.not_to be_valid
    end
  end

  # Associations
  describe "associations" do
    it "belongs to a game" do
      is_expected.to respond_to(:game)
    end

    it "has many votes that are destroyed with the player" do
      is_expected.to respond_to(:votes)
      player = create(:player)
      create(:vote, player: player)
      expect { player.destroy }.to change { Vote.count }.by(-1)
    end

    it "has many rounds through votes" do
      is_expected.to respond_to(:rounds)
    end
  end

  # Instance methods
  describe "#vote_in_round" do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let(:player) { create(:player, game: game) }

    it "creates a vote for the round" do
      expect { player.vote_in_round(round, 5) }.to change { Vote.count }.by(1)
    end

    it "sets the vote score" do
      vote = player.vote_in_round(round, 8)
      expect(vote.score).to eq(8)
    end

    it "updates existing vote if already exists" do
      first_vote = player.vote_in_round(round, 5)
      second_vote = player.vote_in_round(round, 8)
      expect(first_vote.id).to eq(second_vote.id)
      expect(second_vote.score).to eq(8)
    end
  end

  describe "#vote_for_round" do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let(:player) { create(:player, game: game) }

    context "when player has voted in the round" do
      let!(:vote) { player.vote_in_round(round, 5) }

      it "returns the vote" do
        expect(player.vote_for_round(round)).to eq(vote)
      end
    end

    context "when player has not voted in the round" do
      it "returns nil" do
        expect(player.vote_for_round(round)).to be_nil
      end
    end
  end
end
