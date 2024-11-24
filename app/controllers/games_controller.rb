class GamesController < ApplicationController
  def index
    @games = Game.order(created_at: :desc)
    render Games::Index.new(games: @games)
  end

  def show
    set_game
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
    Game.transaction do
      @game = Game.create!(game_params)
      @player = @game.players.create!(name: @game.owner_name)
      @game.owner = @player
      @game.save
      @game.start_new_round
    end

    session["game_#{@game.id}_player_id"] = @player.id
    redirect_to @game, notice: "Game was successfully created."
  rescue StandardError => e
    debugger
    render :new, status: :unprocessable_entity
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
      # Set the current player in the session
      set_current_player(@player)
      redirect_to @game, notice: "Successfully joined the game."
    else
      render :join, status: :unprocessable_entity
    end
  end

  # def start_new_round
  #   set_game
  #   @game.start_new_round(story_title: params[:round][:story_title])
  #   redirect_to @game, notice: "New round started!"
  # end

  private

  def set_game
    @game = Game.find_by!(uuid: params[:id])
  end

  def game_params
    params.require(:game).permit(:owner_name, :title)
  end

  def player_params
    params.require(:player).permit(:name)
  end
end
