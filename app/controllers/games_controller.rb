class GamesController < ApplicationController
  def index
    @games = Game.order(created_at: :desc)
    render Games::Index.new(games: @games)
  end

  def show
    @game = Game.find(params[:id])
    @current_round = @game.current_round
    render Games::Show.new(game: @game, current_round: @current_round)
  end

  def new
    @game = Game.new
    render Games::New.new(game: @game)
  end

  def create
    @game = Game.new(game_params)

    if @game.save
      @game.players.create!(name: @game.owner_name)
      @game.start_new_round
      redirect_to @game, notice: "Game was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def join
    @game = Game.find(params[:id])
    @player = @game.players.build
    render Games::Join.new(game: @game, player: @player)
  end

  def add_player
    @game = Game.find(params[:id])
    @player = @game.players.build(player_params)

    if @player.save
      # Set the current player in the session
      set_current_player(@player)
      redirect_to @game, notice: "Successfully joined the game."
    else
      render :join, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:owner_name, :title)
  end

  def player_params
    params.require(:player).permit(:name)
  end
end
