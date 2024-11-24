# frozen_string_literal: true

class Games::Index < ApplicationView
  include Phlex::Rails::Helpers::LinkTo

  def initialize(games:)
    @games = games
  end

  def view_template
    div(class: "min-h-screen bg-gradient-to-b from-blue-50 to-white py-12 px-4 sm:px-6 lg:px-8") do
      div(class: "max-w-5xl mx-auto space-y-12") do
        # Hero Section
        div(class: "text-center space-y-4") do
          h1(class: "text-5xl font-extrabold text-gray-900 tracking-tight") do
            plain "Planning Poker"
          end
          p(class: "max-w-2xl mx-auto text-xl text-gray-600") do
            plain "Make sprint planning collaborative and fun"
          end

          # Primary CTA
          div(class: "mt-8") do
            link_to(
              new_game_path,
              class: "inline-block px-8 py-4 text-lg font-medium text-white bg-blue-600 rounded-lg shadow-lg hover:bg-blue-700 transform transition duration-200 hover:-translate-y-1"
            ) do
              plain "Start New Game"
            end
          end
        end

        # Features Section
        div(class: "bg-white rounded-2xl shadow-sm border border-gray-100 p-8 md:p-12") do
          h2(class: "text-2xl font-bold text-gray-900 mb-6") { "How It Works" }
          div(class: "grid md:grid-cols-3 gap-8") do
            div(class: "space-y-3") do
              h3(class: "text-lg font-semibold text-gray-900") { "1. Create a Game" }
              p(class: "text-gray-600") { "Start a new session and invite your team members" }
            end
            div(class: "space-y-3") do
              h3(class: "text-lg font-semibold text-gray-900") { "2. Add Stories" }
              p(class: "text-gray-600") { "Input the user stories you want to estimate" }
            end
            div(class: "space-y-3") do
              h3(class: "text-lg font-semibold text-gray-900") { "3. Vote Together" }
              p(class: "text-gray-600") { "Team members vote simultaneously to avoid bias" }
            end
          end
        end

        # Active Games Section
        if @games.any?
          div(class: "space-y-6") do
            h2(class: "text-2xl font-bold text-center text-gray-900") { "Active Games" }

            div(class: "grid md:grid-cols-2 lg:grid-cols-3 gap-6") do
              @games.each do |game|
                link_to(game_path(game), class: "block") do
                  div(class: "group bg-white rounded-xl p-6 border border-gray-200 hover:border-blue-200 hover:shadow-lg transition duration-200") do
                    div do
                      div(class: "flex items-center justify-between mb-4") do
                        h3(class: "text-lg font-semibold text-gray-900 group-hover:text-blue-600") do
                          plain game.title.presence || "Planning Poker Game"
                        end
                        if game.current_round&.voting_in_progress?
                          div(class: "px-3 py-1 text-xs font-medium text-green-700 bg-green-100 rounded-full") do
                            "Active"
                          end
                        end
                      end

                      div(class: "flex items-center justify-between text-sm text-gray-500") do
                        div { plain "Created by #{game.owner_name}" }
                        div { plain "#{game.players.count} players" }
                      end
                    end
                  end
                end
              end
            end
          end
        else
          div(class: "text-center py-12 bg-white rounded-xl border border-gray-200") do
            h3(class: "text-lg font-medium text-gray-900 mb-2") { "No Active Games" }
            p(class: "text-gray-500") { "Start a new game to begin estimation" }
          end
        end
      end
    end
  end
end
