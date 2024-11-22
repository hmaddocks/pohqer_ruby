class Games::Show < ApplicationView
  def initialize(game:, current_round:, current_player:)
    @game = game
    @current_round = current_round
    @current_player = current_player
  end

  def template
    div(class: "max-w-4xl mx-auto p-4") do
      render GameComponent.new(
        game: @game,
        current_player: @current_player
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

          # Only show vote dropdown for current player
          if player == @current_player
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
                Vote::FIBONACCI_SCORES.each do |vote|
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
          else
            # For other players, show their vote if exists
            existing_vote = player.vote_for_round(@current_round)
            span(class: "player-vote") do
              existing_vote ? existing_vote.score : "Not voted"
            end
          end
        end
      end
    end
  end
end
