# frozen_string_literal: true

class GameComponent < ApplicationComponent
  def initialize(game:, current_player: nil)
    @game = game
    @current_player = current_player
    @current_round = game.current_round
  end

  def view_template
    div(class: "max-w-4xl mx-auto p-4") do
      div(class: "py-4") do
        render RoundComponent.new(round: @current_round, current_player: @current_player)
      end

      div(class: "py-4") do
        render PlayersListComponent.new(game: @game, current_round: @current_round)
      end
    end
  end
end
