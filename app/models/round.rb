# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :game
  has_many :votes, dependent: :destroy
  has_many :players, through: :votes

  delegate :count, to: :votes, prefix: true

  def voting_in_progress?
    !finished?
  end

  def finish!
    update!(finished: true)
  end

  def average_score
    return nil if votes.none?

    votes.average(:score).to_f.round(1)
  end

  def all_players_voted?
    votes_count == game.players.count
  end
end
