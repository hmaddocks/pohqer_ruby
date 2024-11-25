require 'rails_helper'

RSpec.describe Round, type: :model do
  # Include FactoryBot methods
  include FactoryBot::Syntax::Methods

  # Subject for the Round model
  subject(:round) { build(:round) }

  # Associations
  describe "associations" do
    it "belongs to a game" do
      is_expected.to respond_to(:game)
    end

    it "has many votes that are destroyed with the round" do
      is_expected.to respond_to(:votes)
      round = create(:round)
      create(:vote, round: round)
      expect { round.destroy }.to change { Vote.count }.by(-1)
    end

    it "has many players through votes" do
      is_expected.to respond_to(:players)
    end
  end

  # Enums
  describe "enums" do
    it "defines status enum with correct values" do
      expect(described_class.statuses).to eq({
        "pending" => 0,
        "in_progress" => 1,
        "finished" => 2
      })
    end
  end

  # Instance methods
  describe "#voting_in_progress?" do
    let(:game) { create(:game) }

    context "when round is in progress" do
      subject(:round) { create(:round, game: game, status: :in_progress) }

      it { is_expected.to be_voting_in_progress }
    end

    context "when round is finished" do
      subject(:round) { create(:round, game: game, status: :finished) }

      it { is_expected.not_to be_voting_in_progress }
    end
  end

  describe "#start!" do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game, status: :pending) }
    let(:story_title) { "New feature implementation" }

    it "updates the round with story title and changes status to in_progress" do
      round.start!(story_title)
      expect(round.story_title).to eq(story_title)
      expect(round).to be_in_progress
    end
  end

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
    let(:player1) { create(:player, game: game) }
    let(:player2) { create(:player, game: game) }
    let(:player3) { create(:player, game: game) }

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
    let(:player1) { create(:player, game: game) }
    let(:player2) { create(:player, game: game) }

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

  describe "#all_players_voted?" do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let!(:player1) { create(:player, game: game) }
    let!(:player2) { create(:player, game: game) }

    context "when not all players have voted" do
      before do
        player1.vote_in_round(round, 5)
      end

      it "returns false" do
        expect(round.all_players_voted?).to be false
      end
    end

    context "when all players have voted" do
      before do
        player1.vote_in_round(round, 5)
        player2.vote_in_round(round, 8)
      end

      it "returns true" do
        expect(round.all_players_voted?).to be true
      end
    end
  end
end
