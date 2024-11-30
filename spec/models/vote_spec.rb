# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
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

      create(:vote, player: player, round: round, score: 5)
      duplicate_vote = build(:vote, player: player, round: round, score: 8)

      expect(duplicate_vote).not_to be_valid
    end
  end
end
