# frozen_string_literal: true

class GameComponent < ApplicationComponent
  attr_reader :game, :round, :current_player

  def initialize(game:, current_player: nil)
    @game = game
    @current_player = current_player
    @round = game.current_round
  end

  def view_template
    div(class: "max-w-4xl mx-auto") do
      div(class: "py-4") do
        render RoundComponent.new(round:, current_player:)
      end

      div(class: "py-4") do
        render PlayersListComponent.new(game:, current_round: round)
      end
    end
  end
end
