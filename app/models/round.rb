# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :game
  has_many :votes, dependent: :delete_all
  has_many :players, through: :votes

  delegate :count, to: :votes, prefix: true

  enum :status, { pending: 0, in_progress: 1, finished: 2 }

  def voting_in_progress? = in_progress?

  def finish! = finished!

  def average_score
    return nil if votes.none?

    votes.where.not(score: 69).average(:score).to_f.round(1)
  end
end
