class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy
  
  validates :owner_name, presence: true

  def current_round
    rounds.last
  end

  def start_new_round(story_title: nil)
    rounds.create!(story_title: story_title)
  end

  def voting_in_progress?
    current_round&.voting_in_progress?
  end
end
