class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = Game.create(game_params)
    current_user.games << game
    game.set_up_game
    redirect_to game_path(game.id)
  end

  def show
    @game = Game.find(params[:id])
  end

  def update
    game = Game.find(params[:id])
    if params[:user_action]
      game.user_action(params[:user_action])
      flash[:ai_action] = game.ai_action
      game.update_game
    else
      game.game_action
      # if game.flop_card_ids.empty?
      #   game.deal_flop
      # elsif !game.turn_card_id
      #   game.deal_turn
      # elsif !game.river_card_id
      #   game.deal_river
      # else
      #   game.update(winner: game.determine_winner)
      # end
    end
    redirect_to game_path(game.id)
  end

  private

  def game_params
    params.require(:game).permit(:player_count, :little_blind, :big_blind)
  end
end
