# frozen_string_literal: true

module Games
  class Index < ApplicationView
    include Phlex::Rails::Helpers::LinkTo

    def initialize(games:)
      @games = games
    end

    def view_template
      div(class: "min-h-screen bg-gradient-to-b from-blue-50 to-white py-12 px-4 sm:px-6 lg:px-8") do
        div(class: "max-w-5xl mx-auto space-y-12") do
          render_hero_section
          render_features_section
        end
      end
    end

    private

    def render_hero_section
      # Hero Section
      div(class: "text-center space-y-4") do
        h1(class: "text-5xl font-extrabold text-gray-900 tracking-tight") do
          plain "Planning Poker"
        end
        p(class: "max-w-2xl mx-auto text-xl text-gray-600") do
          plain "Make sprint planning collaborative and fun"
        end

        div(class: "mt-8") do
          link_to(
            new_game_path,
            class: "inline-block px-8 py-4 text-lg font-medium text-white bg-blue-600 rounded-lg shadow-lg hover:bg-blue-700 transform transition duration-200 hover:-translate-y-1"
          ) do
            plain "Start New Game"
          end
        end
      end
    end

    def render_features_section
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
            p(class: "text-gray-600") { "Each round estimate a User Story" }
          end
          div(class: "space-y-3") do
            h3(class: "text-lg font-semibold text-gray-900") { "3. Vote Together" }
            p(class: "text-gray-600") { "Team members vote simultaneously to avoid bias" }
          end
        end
      end
    end
  end
end
