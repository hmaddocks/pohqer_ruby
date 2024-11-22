class Games::Show < ApplicationView
  def initialize(game:, current_round:)
    @game = game
    @current_round = current_round
  end

  def template
    div(class: "max-w-4xl mx-auto p-4") do
      render GameComponent.new(
        game: @game, 
        current_player: nil  # You'll want to implement current_player logic later
      )
    end
  end
end
