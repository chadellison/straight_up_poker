class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = Game.create(game_params)
    game.add_players
    redirect_to game_path
  end

  private

  def game_params
    params.require(:game).permit(:player_count)
  end
end
