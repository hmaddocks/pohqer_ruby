class PlayersListComponent < Phlex::HTML
  def initialize(game:, current_round:)
    @game = game
    @current_round = current_round
  end

  def view_template
    div(class: "bg-white shadow rounded-lg p-6") do
      h3(class: "text-lg font-semibold mb-4") do
        plain "Players (#{@game.players.count})"
      end

      div(class: "grid grid-cols-2 md:grid-cols-3 gap-4") do
        @game.players.each do |player|
          render PlayerCardComponent.new(
            player: player,
            current_round: @current_round
          )
        end
      end
    end
  end
end
