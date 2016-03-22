class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = Game.create(game_params)
    current_user.refresh.games << game
    game.set_up_game
    flash[:initial_actions] = game.initial_actions
    redirect_to game_path(game.id)
  end

  def show
    @game = Game.find(params[:id])
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    game = Game.find(params[:id])
    if game.user_action(params[:user_action], params[:user]) == "Error"
      flash[:error] = "You cannot bet less than the little blind or more than you have"
    elsif params[:user_action]
      flash[:ai_action] = game.ai_action(params[:user_action], params[:user])
      game.update_game
    else
      game.game_action
    end
    game.refresh if params["refresh"]
    redirect_to game_path(game.id)
  end

  private

  def game_params
    params.require(:game).permit(:player_count, :little_blind, :big_blind, :current_bet)
  end
end
