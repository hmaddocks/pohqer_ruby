# frozen_string_literal: true

class VotingComponent < Phlex::HTML
  include Rails.application.routes.url_helpers

  FIBONACCI_SCORES = Vote::FIBONACCI_SCORES

  def initialize(round:, current_player:)
    @round = round
    @current_player = current_player
    @current_vote = @current_player&.vote_for_round(@round)
  end

  def view_template
    div(class: "grid grid-cols-4 gap-4", data_controller: "voting") do
      FIBONACCI_SCORES.each do |score|
        button_classes = [
          "p-4 text-xl font-bold rounded transition-colors",
          @current_vote&.score == score ? "bg-blue-500 text-white" : "bg-gray-100 hover:bg-gray-200"
        ].join(" ")

        form(
          action: vote_game_round_path(@round.game, @round),
          method: "post",
          class: "contents"
        ) do
          input(type: "hidden", name: "player_id", value: @current_player&.id)
          input(type: "hidden", name: "score", value: score)

          button(
            type: "submit",
            class: button_classes,
            disabled: @current_player.nil?
          ) { score }
        end
      end
    end
  end
end
