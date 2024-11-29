# frozen_string_literal: true

class RoundResultsComponent < ApplicationComponent
  include Phlex::Rails::Helpers::FormWith

  def initialize(round:)
    @round = round
  end

  def view_template
    div(class: "space-y-6") do
      div(class: "text-center") do
        h3(class: "text-lg font-semibold mb-2") { "Results" }

        if @round.score.present?
          div(class: "text-3xl font-bold text-blue-500") do
            plain "Score: #{@round.score}"
          end
          div(class: "text-gray-500") { "#{@round.votes_count} votes" }
        elsif @round.votes_count.positive?
          div(class: "text-3xl font-bold text-blue-500") do
            plain "Average: #{@round.average_score}"
          end
          div(class: "text-gray-500") { "#{@round.votes_count} votes" }
        else
          div(class: "text-gray-500") { "No votes recorded" }
        end
      end

      if @round.finished?
        div(class: "grid grid-cols-2 md:grid-cols-3 gap-4") do
          @round.votes.includes(:player).find_each do |vote|
            div(class: "bg-gray-50 p-4 rounded") do
              div(class: "font-medium") { vote.player_name }
              div(class: "text-2xl font-bold text-blue-500") { vote.score }
            end
          end
        end

        div(class: "mt-6") do
          if @round.score.blank?
            form_with(model: @round, url: game_round_path(@round.game, @round),
                      class: "flex flex-col items-center gap-4") do |f|
              div(class: "w-full max-w-xs") do
                label(class: "block text-sm font-medium text-gray-700 mb-1") { "Enter Round Score" }
                f.number_field :score,
                               class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm",
                               placeholder: "Enter score",
                               required: true,
                               min: 0
              end

              f.submit "Save Score",
                       class: "inline-flex justify-center rounded-md border border-transparent bg-blue-600 py-2 px-4 text-sm font-medium text-white shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            end
          end
        end
      end
    end
  end
end
