# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :game
  has_many :votes, dependent: :delete_all
  has_many :rounds, through: :votes

  validates :name, presence: true

  def vote_in_round(round, score)
    votes.find_or_initialize_by(round: round).tap do |vote|
      vote.score = score
      vote.save!
    end
  end

  def vote_for_round(round) = votes.find_by(round: round)
end
