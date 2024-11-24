# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy
  belongs_to :owner, class_name: 'Player', optional: true

  validates :owner_name, presence: true
  validates :uuid, presence: true, uniqueness: true

  before_validation :ensure_uuid, on: :create

  def to_param
    uuid
  end

  def current_round
    rounds.last
  end

  def start_new_round(story_title: nil)
    if story_title.present?
      rounds.create!(story_title: story_title, status: :in_progress)
    else
      rounds.create!
    end
  end

  def voting_in_progress?
    current_round&.in_progress?
  end

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
