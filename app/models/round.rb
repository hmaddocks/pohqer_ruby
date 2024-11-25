# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :game
  has_many :votes, dependent: :destroy
  has_many :players, through: :votes

  delegate :count, to: :votes, prefix: true

  enum :status, { pending: 0, in_progress: 1, finished: 2 }

  def voting_in_progress?
    in_progress?
  end

  def finish!
    finished!
  end

  def start!(story_title)
    update!(story_title: story_title, status: :in_progress)
  end

  def average_score
    return nil if votes.none?

    votes.average(:score).to_f.round(1)
  end

  def all_players_voted?
    votes_count == game.players.count
  end
end
