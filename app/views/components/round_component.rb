# frozen_string_literal: true

class RoundComponent < ApplicationComponent
  attr_reader :round, :current_player

  def initialize(round:, current_player:)
    @round = round
    @current_player = current_player
  end

  def view_template
    turbo_frame_tag("round-#{round.id}") do
      div(class: "py-4") do
        div(class: "bg-white shadow rounded-lg p-6", data_controller: "round") do
          render RoundHeaderComponent.new(round: round)
        end

        unless round.pending?
          div(class: "bg-white shadow rounded-lg p-6 mt-8") do
            if round.finished?
              render RoundResultsComponent.new(round: round)
            else
              render VotingComponent.new(round: round, current_player: current_player)
            end
          end
        end
      end
    end
  end
end
