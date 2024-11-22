class Games::Index < ApplicationView
  include Phlex::Rails::Helpers::LinkTo

  def initialize(games:)
    @games = games
  end

  def template
    div(class: "max-w-4xl mx-auto p-4") do
      div(class: "flex justify-between items-center mb-8") do
        h1(class: "text-3xl font-bold") { "Planning Poker Games" }

        link_to(
          "New Game",
          new_game_path,
          class: "bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
        )
      end

      div(class: "grid gap-6") do
        @games.each do |game|
          link_to(game_path(game), class: "block") do
            div(class: "bg-white shadow rounded-lg p-6 hover:shadow-md transition-shadow") do
              div(class: "flex justify-between items-start") do
                div do
                  h2(class: "text-xl font-semibold mb-2") do
                    plain game.title.presence || "Planning Poker Game"
                  end

                  div(class: "text-gray-600") do
                    plain "Created by #{game.owner_name}"
                  end
                end

                div(class: "text-right") do
                  div(class: "text-sm text-gray-500") do
                    plain "#{game.players.count} players"
                  end

                  if game.current_round&.voting_in_progress?
                    div(class: "text-sm text-green-500") { "Voting in progress" }
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
