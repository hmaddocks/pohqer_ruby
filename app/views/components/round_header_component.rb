# frozen_string_literal: true

class RoundHeaderComponent < ApplicationComponent
  include Phlex::Rails::Helpers::FormWith
  include Rails.application.routes.url_helpers

  attr_reader :round, :game

  def initialize(round:)
    @round = round
    @game = round.game
  end

  def view_template
    div(class: "flex justify-between items-center mb-6") do
      div do
        h2(class: "text-xl font-semibold") do
          plain round.story_title if round.story_title?
        end
      end

      if round.in_progress? && !(round == round.game.rounds.first && round.pending?)
        finish_round_form
      else
        start_new_round_form
      end
    end
  end

  def finish_round_form
    form(action: finish_game_round_path(game, round), method: "post") do
      button(
        type: "submit",
        class: "bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 disabled:opacity-50 disabled:cursor-not-allowed",
        disabled: round.votes_count.zero?
      ) { "Finish Round" }
    end
  end

  def start_new_round_form
    form(action: game_rounds_path(game), method: "post", class: "flex gap-2") do
      div(class: "flex gap-2") do
        input(
          type: "text",
          name: "round[story_title]",
          class: "rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm",
          required: true,
          placeholder: "Enter story title"
        )
        button(
          type: "submit",
          class: "bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
        ) { "Start New Round" }
      end
    end
  end
end
