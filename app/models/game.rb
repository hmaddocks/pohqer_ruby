# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy
  belongs_to :owner, class_name: 'Player', optional: true

  validates :owner_name, presence: true
  validates :uuid, presence: true, uniqueness: true

  before_validation :ensure_uuid, on: :create

  def to_param = uuid

  def current_round = rounds.last

  def start_new_round(story_title: nil) = rounds.create!(story_title: story_title, status: :in_progress)

  private

  def ensure_uuid = self.uuid ||= SecureRandom.uuid
end
