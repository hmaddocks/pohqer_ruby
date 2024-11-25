# frozen_string_literal: true

class Games::Show < ApplicationView
  def initialize(game:, current_round:, current_player:)
    @game = game
    @current_round = current_round
    @current_player = current_player
  end

  def view_template
    div(class: "max-w-4xl mx-auto p-4") do
      render GameComponent.new(
        game: @game,
        current_player: @current_player
      )

      # All rounds section
      div(class: "mt-8") do
        h2(class: "text-2xl font-bold mb-4") { "Game Rounds" }

        @game.rounds.order(created_at: :desc).each do |round|
          render RoundSummaryComponent.new(round: round)
        end
      end
    end
  end
end
