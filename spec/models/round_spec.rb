# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Round, type: :model do
  # Subject for the Round model
  subject(:round) { build(:round) }

  describe "#finish!" do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game, status: :in_progress) }

    it "marks the round as finished" do
      round.finish!
      expect(round).to be_finished
    end
  end

  describe "#average_score" do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let(:player1) { create(:player, game: game) } # rubocop:disable RSpec/IndexedLet
    let(:player2) { create(:player, game: game) } # rubocop:disable RSpec/IndexedLet
    let(:player3) { create(:player, game: game) } # rubocop:disable RSpec/IndexedLet

    context "when no votes exist" do
      it "returns nil" do
        expect(round.average_score).to be_nil
      end
    end

    context "when votes exist" do
      before do
        player1.vote_in_round(round, 5)
        player2.vote_in_round(round, 8)
      end

      it "calculates the average score" do
        expect(round.average_score).to eq(6.5)
      end
    end

    context "when some votes are 69 (coffee break)" do
      before do
        player1.vote_in_round(round, 5)
        player2.vote_in_round(round, 69)
        player3.vote_in_round(round, 8)
      end

      it "excludes coffee break votes from average calculation" do
        expect(round.average_score).to eq(6.5)
      end
    end
  end

  describe "#votes_count" do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let(:player1) { create(:player, game: game) } # rubocop:disable RSpec/IndexedLet
    let(:player2) { create(:player, game: game) } # rubocop:disable RSpec/IndexedLet

    context "when no votes exist" do
      it "returns 0" do
        expect(round.votes_count).to eq(0)
      end
    end

    context "when votes exist" do
      before do
        player1.vote_in_round(round, 5)
        player2.vote_in_round(round, 8)
      end

      it "returns the number of votes" do
        expect(round.votes_count).to eq(2)
      end
    end
  end
end
