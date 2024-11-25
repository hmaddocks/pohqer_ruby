# frozen_string_literal: true

class Vote < ApplicationRecord
  FIBONACCI_SCORES = [1, 2, 3, 5, 8, 13, 21, 69].freeze

  belongs_to :player
  belongs_to :round

  validates :score, inclusion: { in: FIBONACCI_SCORES }
  validates :player_id, uniqueness: { scope: :round_id }
end
