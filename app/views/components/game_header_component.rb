class GameHeaderComponent < Phlex::HTML
  include Rails.application.routes.url_helpers

  def initialize(game:)
    @game = game
  end

  def template
    div(class: "mb-8") do
      h1(class: "text-3xl font-bold mb-2") do
        plain @game.title.presence || "Planning Poker Game"
      end

      div(class: "text-gray-600") do
        plain "Created by #{@game.owner_name}"
      end

      div(class: "mt-4") do
        button(
          class: "bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600",
          data_controller: "clipboard",
          data_action: "click->clipboard#copy",
          data_clipboard_text_value: join_game_path(@game)
        ) { "Copy Join Link" }
      end
    end
  end
end
