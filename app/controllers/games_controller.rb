class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = Game.new(params[:player_count], [:little_blind])
    binding.pry
    # current_user.games << game
    game.user << current_user
    game.set_up_game
    session[:game] = game
    redirect_to game_path
  end

  def show
    # @game = Game.find(params[:id])
  end

  def edit
    # @game = Game.find(params[:id])
  end

  def update
    # game = Game.find(params[:id])
    if params[:user_action]
      game.user_action(params[:user_action], params[:user])
      flash[:ai_action] = game.ai_action(params[:user_action], params[:user])
      game.update_game
    else
      game.game_action
    end
    redirect_to game_path(game.id)
  end

  private

  def game_params
    params.require(:game).permit(:player_count, :little_blind, :big_blind, :current_bet)
  end
end
