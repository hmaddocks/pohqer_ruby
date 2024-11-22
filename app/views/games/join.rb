class Games::Join < ApplicationView
  def initialize(game:, player:)
    @game = game
    @player = player
  end

  def view_template
    div(class: "max-w-4xl mx-auto p-4") do
      h1(class: "text-2xl font-bold mb-6") { "Join Game: #{@game.title}" }

      form(
        method: "post",
        action: add_player_game_path(@game),
        class: "space-y-6"
      ) do
        if @player.errors.any?
          div(class: "rounded-md bg-red-50 p-4 mb-4") do
            h2(class: "text-red-800 text-sm font-medium") { "#{pluralize(@player.errors.count, 'error')} prohibited this player from being saved:" }
            ul(class: "mt-2 text-sm text-red-700") do
              @player.errors.full_messages.each do |message|
                li { message }
              end
            end
          end
        end

        div(class: "space-y-2") do
          label(for: "player_name", class: "block text-sm font-medium text-gray-700") { "Name" }
          input(
            type: "text",
            name: "player[name]",
            id: "player_name",
            placeholder: "Your name",
            required: true,
            class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
          )
        end

        div(class: "mt-6") do
          input(
            type: "submit",
            value: "Join Game",
            class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
          )
        end
      end

      a(
        href: game_path(@game),
        class: "mt-4 inline-block text-sm text-blue-600 hover:text-blue-800"
      ) { "← Back to Game" }
    end
  end
end
