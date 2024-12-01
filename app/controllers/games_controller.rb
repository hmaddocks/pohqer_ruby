# frozen_string_literal: true

class GamesController < ApplicationController
  def index
    @games = Game.order(created_at: :desc)
    render Games::Index.new(games: @games)
  end

  def show
    set_game
    redirect_to root_path and return unless @game

    @current_round = @game.current_round
    @current_player = current_player

    render Games::Show.new(
      game: @game,
      current_round: @current_round,
      current_player: @current_player
    )
  end

  def new
    @game = Game.new
    render Games::New.new(game: @game)
  end

  def create
    @game = Game.new(game_params)
    Game.transaction do
      @game.save!
      @player = @game.players.create!(name: @game.owner_name)
      @game.owner = @player
      @game.save!
      @game.start_new_round
    end

    session["game_#{@game.id}_player_id"] = @player.id
    redirect_to @game
  rescue StandardError
    render Games::New.new(game: @game), status: :unprocessable_entity
  end

  def join
    set_game
    @player = @game.players.build
    render Games::Join.new(game: @game, player: @player)
  end

  def add_player
    set_game
    @player = @game.players.build(player_params)

    if @player.save
      set_current_player(@player)
      # Turbo::StreamsChannel.broadcast_replace_to(
      #   "game_#{@game.id}",
      #   target: "game-#{@game.id}-players",
      #   html: PlayersListComponent.new(game: @game, current_round: @game.current_round).call
      # )
      redirect_to @game
    else
      render :join, status: :unprocessable_entity
    end
  end

  private

  def set_game
    @game = Game.find_by(uuid: params[:id])
  end

  def game_params
    params.require(:game).permit(:owner_name, :title)
  end

  def player_params
    params.require(:player).permit(:name)
  end
end
