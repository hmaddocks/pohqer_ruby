class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  protect_from_forgery with: :exception

  helper_method :current_player, :current_game

  private

  def current_player
    @current_player ||= find_current_player
  end

  def current_game
    @current_game ||= find_current_game
  end

  def find_current_player
    # First, check if there's a player ID in the session for the current game
    if current_game && session["game_#{current_game.id}_player_id"]
      current_game.players.find_by(id: session["game_#{current_game.id}_player_id"])
    end
  end

  def find_current_game
    # Attempt to find the current game from the request parameters
    if params[:controller] == "games" && params[:action] == "show"
      Game.find(params[:id])
    elsif params[:game_id]
      Game.find(params[:game_id])
    elsif params[:id] && [ "games", "rounds" ].include?(params[:controller])
      # For nested resources like rounds
      Game.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def set_current_player(player)
    # Set the current player for a specific game in the session
    return unless player && player.game
    session["game_#{player.game.id}_player_id"] = player.id
  end
end
