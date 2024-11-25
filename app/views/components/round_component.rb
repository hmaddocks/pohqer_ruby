# frozen_string_literal: true

class RoundComponent < Phlex::HTML
  def initialize(round:, current_player:)
    @round = round
    @current_player = current_player
  end

  def view_template
    div(class: "space-y-4") do
      div(class: "bg-white shadow rounded-lg p-6", data_controller: "round") do
        render RoundHeaderComponent.new(round: @round)
      end

      div(class: "bg-white shadow rounded-lg p-6") do
        if @round.finished?
          render RoundResultsComponent.new(round: @round)
        else
          render VotingComponent.new(
            round: @round,
            current_player: @current_player
          )
        end
      end
    end
  end
end
