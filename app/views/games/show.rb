class Games::Show < ApplicationView
  FIBONACCI_VOTES = [ 1, 2, 3, 5, 8, 13, 21, 34, 55, 89 ]

  def initialize(game:, current_round:)
    @game = game
    @current_round = current_round
  end

  def template
    div(class: "max-w-4xl mx-auto p-4") do
      render GameComponent.new(
        game: @game,
        current_player: nil  # Placeholder for now
      )

      # Voting section for current round
      if @current_round
        voting_section
      end
    end
  end

  private

  def voting_section
    div(class: "voting-section mt-4") do
      h2(class: "text-xl font-bold mb-2") { "Voting for Current Round" }

      # Players list for voting
      @game.players.each do |player|
        div(class: "player-vote-row flex items-center space-x-2") do
          span { player.name }

          form(
            method: "post",
            action: vote_game_round_path(@game, @current_round),
            class: "vote-form inline-flex items-center"
          ) do
            # Hidden inputs for form submission
            input(type: "hidden", name: "player_id", value: player.id)

            # Vote score dropdown
            select(
              name: "score",
              class: "form-select mr-2",
              required: true
            ) do
              # Default option
              option(value: "") { "Select Vote" }

              # Existing vote or default options
              FIBONACCI_VOTES.each do |vote|
                existing_vote = player.vote_for_round(@current_round)
                
                option(
                  value: vote, 
                  selected: existing_vote&.score == vote
                ) { vote }
              end
            end

            # Submit button
            input(
              type: "submit",
              value: "Vote",
              class: "btn btn-primary"
            )
          end
        end
      end
    end
  end
end
