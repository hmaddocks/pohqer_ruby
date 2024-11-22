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

    it "updates an existing vote" do
      # First vote
      first_vote = player.vote_in_round(round, 5)
      expect(first_vote.score).to eq(5)

      # Update vote
      updated_vote = player.vote_in_round(round, 8)
      expect(updated_vote.id).to eq(first_vote.id)
      expect(updated_vote.score).to eq(8)
    end
  end

  describe "#vote_for_round" do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let(:player) { create(:player, game: game) }

    it "returns nil when no vote exists" do
      expect(player.vote_for_round(round)).to be_nil
    end

    it "returns the vote for a specific round" do
      vote = create(:vote, player: player, round: round, score: 5)
      expect(player.vote_for_round(round)).to eq(vote)
    end

    it "returns the correct vote when multiple rounds exist" do
      another_round = create(:round, game: game)
      vote = create(:vote, player: player, round: round, score: 5)
      another_vote = create(:vote, player: player, round: another_round, score: 8)

      expect(player.vote_for_round(round)).to eq(vote)
      expect(player.vote_for_round(another_round)).to eq(another_vote)
    end
  end
end
