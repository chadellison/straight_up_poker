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
    if !game.flop
      game.deal_flop
    # elsif !game.turn
    #   game.deal_turn
    # else
    #   game.deal_river
    end
    redirect_to game_path(game.id)
  end

  private

  def game_params
    params.require(:game).permit(:player_count, :little_blind, :big_blind)
  end
end
