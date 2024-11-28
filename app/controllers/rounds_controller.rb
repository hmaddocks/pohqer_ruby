# frozen_string_literal: true

class RoundsController < ApplicationController
  before_action :set_game
  before_action :set_round, only: %i[finish vote]

  def create
    @round = @game.start_new_round(story_title: params[:round][:story_title])
    redirect_to @game, notice: "New round started."
  end

  def finish
    @round.finish!
    redirect_to @game, notice: "Round finished. Scores revealed!"
  end

  def vote
    @player = @game.players.find(params[:player_id])
    @player.vote_in_round(@round, params[:score].to_i)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "round-#{@round.id}",
            RoundComponent.new(round: @round, current_player: @player)
          ),
          turbo_stream.replace(
            "game-#{@game.id}-players",
            PlayersListComponent.new(game: @game, current_round: @game.current_round)
          )
        ]
      end
      format.html { redirect_to @game, notice: "Vote recorded." }
    end
  end

  private

  def set_game
    @game = Game.find_by!(uuid: params[:game_id])
  end

  def set_round
    @round = @game.rounds.find(params[:id])
  end
end
