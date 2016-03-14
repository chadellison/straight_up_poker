class CallsController < ApplicationController
  def create
    # bet_amount = Game.find(params[:game_id]).ai_players.max_by do |ai_player|
    #   ai_player.last_bet
    # end.last_bet
    game = Game.find(params[:game_id])
    call_amount = game.ai_players.maximum(:last_bet)
    bet_amount = call_amount - current_user.last_bet
    current_user.bet(bet_amount)
    game.ai_action  #perhaps you could make game.ai_action the content of a flash
    redirect_to game_path(params[:game_id])
  end
end
