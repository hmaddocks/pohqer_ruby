# frozen_string_literal: true

class RoundResultsComponent < Phlex::HTML
  def initialize(round:)
    @round = round
  end

  def view_template
    div(class: "space-y-6") do
      div(class: "text-center") do
        h3(class: "text-lg font-semibold mb-2") { "Results" }

        if @round.votes_count > 0
          div(class: "text-3xl font-bold text-blue-500") do
            plain "Average: #{@round.average_score}"
          end
        else
          div(class: "text-gray-500") { "No votes recorded" }
        end
      end

      if @round.finished?
        div(class: "grid grid-cols-2 md:grid-cols-3 gap-4") do
          @round.votes.includes(:player).each do |vote|
            div(class: "bg-gray-50 p-4 rounded") do
              div(class: "font-medium") { vote.player.name }
              div(class: "text-2xl font-bold text-blue-500") { vote.score }
            end
          end
        end
      end
    end
  end
end
