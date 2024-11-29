# frozen_string_literal: true

class RoundsController < ApplicationController
  before_action :set_game
  before_action :set_round, only: %i[finish vote update]

  def create
    @round = @game.start_new_round(story_title: params[:round][:story_title])
    redirect_to @game
  end

  def finish
    @round.finish!
    redirect_to @game
  end

  def vote
    @player = @game.players.find(params[:player_id])
    @player.vote_in_round(@round, params[:score].to_i)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          [turbo_stream.replace(
            "round_#{@round.id}",
            RoundComponent.new(round: @round, current_player: @player)
          ),
           turbo_stream.replace(
             "player_#{@player.id}",
             PlayerCardComponent.new(player: @player, current_round: @round)
           )]
      end
      format.html { redirect_to @game }
    end
  end

  def update
    if @round.update(round_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "round_#{@round.id}",
            RoundComponent.new(round: @round, current_player: current_player)
          )
        end
        format.html { redirect_to @game }
      end
    else
      redirect_to @game
    end
  end

  private

  def set_game
    @game = Game.find_by!(uuid: params[:game_id])
  end

  def set_round
    @round = @game.rounds.find(params[:id])
  end

  def round_params
    params.require(:round).permit(:score)
  end
end
