# frozen_string_literal: true

class RoundSummaryComponent < ApplicationComponent
  def initialize(round:)
    @round = round
  end

  def view_template
    div(class: "bg-white shadow rounded p-4 mb-2") do
      div(class: "flex justify-between items-center") do
        div(class: "font-medium") { @round.story_title }

        if @round.votes.any?
          div(class: "flex space-x-4") do
            @round.votes.includes(:player).find_each do |vote|
              div(class: "text-sm text-gray-600") do
                span { vote.player_name }
                span(class: "mx-1") { ":" }
                span(class: "font-medium") { vote.score }
              end
            end
          end
        else
          div(class: "text-sm text-gray-500 italic") { "No votes recorded" }
        end
      end
    end
  end
end
