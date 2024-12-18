# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  protect_from_forgery with: :exception

  helper_method :current_player, :current_game

  layout -> { ApplicationLayout }

  private

  def current_player
    @current_player ||= find_current_player
  end

  def current_game
    @current_game ||= find_current_game
  end

  def find_current_game
    # Find the current game from the request parameters
    if params[:controller] == "games" && params[:action] == "show"
      Game.find_by!(uuid: params[:id])
    elsif params[:game_id]
      Game.find_by!(uuid: params[:game_id])
    elsif params[:id] && %w[games rounds].include?(params[:controller])
      # For nested resources like rounds
      Game.find_by!(uuid: params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def find_current_player
    # Find the current player for the current game
    return unless current_game

    session_key = "game_#{current_game.id}_player_id"
    current_game.players.find_by(id: session[session_key])
  end

  def set_current_player(player)
    # Set the current player for a specific game in the session
    return unless player&.game

    session_key = "game_#{player.game.id}_player_id"
    session[session_key] = player.id
  end
end
