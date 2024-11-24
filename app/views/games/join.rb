class Games::Join < ApplicationView
  def initialize(game:, player:)
    @game = game
    @player = player
  end

  def view_template
    div(class: "join-game-container") do
      h1 { "Join Game: #{@game.title}" }

      form(
        method: "post",
        action: add_player_game_path(@game),
        class: "join-game-form"
      ) do
        if @player.errors.any?
          div(class: "error_explanation") do
            h2 { "#{pluralize(@player.errors.count, 'error')} prohibited this player from being saved:" }
            ul do
              @player.errors.full_messages.each do |message|
                li { message }
              end
            end
          end
        end

        div(class: "field") do
          label(for: "player_name") { "Name" }
          input(
            type: "text",
            name: "player[name]",
            id: "player_name",
            placeholder: "Your name",
            required: true
          )
        end

        div(class: "actions") do
          input(
            type: "submit",
            value: "Join Game",
            class: "btn btn-primary"
          )
        end
      end

      a(
        href: game_path(@game),
        class: "back-link"
      ) { "Back to Game" }
    end
  end
end
