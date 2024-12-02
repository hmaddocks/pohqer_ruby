# frozen_string_literal: true

module Games
  class Show < ApplicationView
    def initialize(game:, current_round:, current_player:)
      @game = game
      @current_round = current_round
      @current_player = current_player
    end

    def view_template
      turbo_stream_from "game_#{@game.id}"

      div(class: "max-w-5xl bg-gradient-to-b from-blue-50 to-white py-6 px-4 sm:px-6 lg:px-8 mx-auto") do
        div(class: "py-4") do
          render GameHeaderComponent.new(game: @game, current_player: @current_player)
        end

        div(class: "py-4") do
          render GameComponent.new(game: @game, current_player: @current_player)
        end

        # All rounds section
        div(class: "py-4") do
          h2(class: "text-2xl font-bold mb-4") { "Game Rounds" }

          @game.rounds.order(created_at: :desc).each do |round|
            render RoundSummaryComponent.new(round: round)
          end
        end
      end
    end
  end
end
