class CallsController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    call_amount = game.ai_players.maximum(:last_bet)
    bet_amount = call_amount - current_user.last_bet
    current_user.bet(bet_amount)
    game.update_game
    flash[:ai_action] = game.ai_action
    redirect_to game_path(params[:game_id])
  end
end
