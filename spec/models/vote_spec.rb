require 'rails_helper'

RSpec.describe Vote, type: :model do
  # Include FactoryBot methods
  include FactoryBot::Syntax::Methods

  # Subject for the Vote model
  subject(:vote) { build(:vote) }

  # Validations
  describe "validations" do
    it { is_expected.to be_valid }

    it "is invalid with a score not in the Fibonacci sequence" do
      vote.score = 4
      expect(subject).not_to be_valid
    end

    it "is invalid with a duplicate player-round combination" do
      game = create(:game)
      round = create(:round, game: game)
      player = create(:player, game: game)

      first_vote = create(:vote, player: player, round: round, score: 5)
      duplicate_vote = build(:vote, player: player, round: round, score: 8)

      expect(duplicate_vote).not_to be_valid
    end
  end

  # Associations
  describe "associations" do
    it "belongs to a player" do
      expect(subject).to respond_to(:player)
    end

    it "belongs to a round" do
      expect(subject).to respond_to(:round)
    end
  end

  # Constants
  describe "FIBONACCI_SCORES" do
    it "contains only Fibonacci numbers" do
      expected_scores = [1, 2, 3, 5, 8, 13, 21, 69]
      expect(Vote::FIBONACCI_SCORES).to eq(expected_scores)
    end
  end
end
