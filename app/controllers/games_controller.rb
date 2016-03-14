class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = Game.create(game_params)
    current_user.games << game
    game.add_players
    game.set_blinds
    # game.deal_pocket_cards
    redirect_to game_path(game.id)
  end

  def show
    @game = Game.find(params[:id])
  end

  private

  def game_params
    params.require(:game).permit(:player_count, :little_blind, :big_blind)
  end
end
