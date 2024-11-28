# frozen_string_literal: true

class PlayerCardComponent < ApplicationComponent
  def initialize(player:, current_round:)
    @player = player
    @current_round = current_round
    @vote = @current_round&.votes&.find_by(player: player)
  end

  def view_template
    div(class: player_card_classes) do
      div(class: "font-medium") { @player.name }

      if @vote
        div(class: "text-sm text-green-500") { "Voted" }
      else
        div(class: "text-sm text-gray-500") { "Not voted" }
      end
    end
  end

  private

  def player_card_classes
    [
      "p-4 rounded",
      @vote ? "bg-green-50" : "bg-gray-50"
    ].join(" ")
  end
end
