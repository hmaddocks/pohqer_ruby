# frozen_string_literal: true

module Games
  class Join < ApplicationView
    include Phlex::Rails::Helpers::FormWith

    def initialize(game:, player:)
      @game = game
      @player = player
    end

    def view_template
      div(class: "max-w-4xl mx-auto p-4") do
        h1(class: "text-2xl font-bold mb-6") { "Join Game: #{@game.title}" }

        form_with(model: [@game, @player], url: add_player_game_path(@game), class: "space-y-6") do |form|
          render_errors if @player.errors.any?

          div(class: "space-y-2") do
            form.text_field :name,
                            required: true,
                            placeholder: "Your name",
                            class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
          end

          div(class: "mt-6") do
            form.submit "Join Game",
                        class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
          end
        end
      end
    end

    def render_errors
      div(class: "rounded-md bg-red-50 p-4 mb-4") do
        h2(class: "text-red-800 text-sm font-medium") do
          "#{pluralize(@player.errors.count, 'error')} prohibited this player from being saved:"
        end
        ul(class: "mt-2 text-sm text-red-700") do
          @player.errors.full_messages.each do |message|
            li { message }
          end
        end
      end
    end
  end
end
