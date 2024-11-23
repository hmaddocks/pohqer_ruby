class GameHeaderComponent < Phlex::HTML
  include Rails.application.routes.url_helpers

  def initialize(game:, current_player: nil)
    @game = game
    @current_player = current_player
  end

  def view_template
    div(class: "mb-8") do
      h1(class: "text-3xl font-bold mb-2") do
        plain @game.title.presence || "Planning Poker Game"
      end

      div(class: "text-gray-600 flex items-center gap-2") do
        plain "Created by #{@game.owner_name}"
        if @current_player == @game.owner
          span(class: "inline-flex items-center rounded-md bg-blue-50 px-2 py-1 text-xs font-medium text-blue-700 ring-1 ring-inset ring-blue-700/10") do
            plain "You are the owner"
          end
        end
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
