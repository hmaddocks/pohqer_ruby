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

      # Voting section for current round
      voting_section if @current_round

      # All rounds section
      div(class: "mt-8") do
        h2(class: "text-2xl font-bold mb-4") { "Game Rounds" }

        @game.rounds.order(created_at: :desc).each do |round|
          render RoundSummaryComponent.new(round: round)
        end
      end
    end
  end

  private

  def voting_section
    div(class: "voting-section mt-4") do
      h2(class: "text-xl font-bold mb-2") { "Voting for Current Round" }

      form(
        method: "post",
        action: vote_game_round_path(@game, @current_round),
        class: "vote-form inline-flex items-center",
        data: { turbo: false }
      ) do
        # Hidden inputs for form submission
        input(type: "hidden", name: "player_id", value: @current_player.id)

        # Vote score dropdown
        select(
          name: "score",
          class: "form-select mr-2 rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50",
          required: true
        ) do
          # Default option
          option(value: "") { "Select Vote" }

          # Existing vote or default options
          Vote::FIBONACCI_SCORES.each do |vote|
            existing_vote = @current_player.vote_for_round(@current_round)

            option(
              value: vote,
              selected: existing_vote&.score == vote
            ) { vote }
          end
        end

        # Submit button
        input(
          type: "submit",
          value: "Vote",
          class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        )
      end
    end
  end
end
