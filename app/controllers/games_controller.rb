class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = Game.create(game_params)
    game.set_up_game(current_user)
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
      game.refresh if params["refresh"]
      # flash[:initial_actions] = game.initial_actions unless game.winner
      flash[:ai_action] = game.ai_action unless game.winner
    end
    redirect_to game_path(game.id)
  end

  private

  def game_params
    params.require(:game).permit(:player_count, :little_blind, :big_blind, :current_bet)
  end
end
