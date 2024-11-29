# frozen_string_literal: true

class RoundSummaryComponent < ApplicationComponent
  attr_reader :round

  def initialize(round:)
    @round = round
  end

  def view_template
    div(class: "bg-white shadow rounded p-4 mb-2") do
      div(class: "flex justify-between items-baseline") do
        div(class: "font-medium") { round.story_title }

        if round.votes.any?
          div(class: "flex items-baseline space-x-4") do
            if round.score.present?
              span(class: "font-medium") { "Score: #{round.score}" }
            elsif round.average_score.present?
              span(class: "font-medium") { "Average: #{round.average_score}" }
            end
            span(class: "text-sm text-gray-500") do
              plain "#{round.votes_count} #{'vote'.pluralize(round.votes_count)}"
            end
          end
        else
          div(class: "text-sm text-gray-500 italic") { "No votes recorded" }
        end
      end
    end
  end
end
