class Game < ActiveRecord::Base
  has_many :ai_players

  def add_players
    players = AiPlayer.first(Game.last.player_count - 1)
    players.each { |player| Game.last.ai_players << player }
  end
end
