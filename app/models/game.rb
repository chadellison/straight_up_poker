class Game < ActiveRecord::Base
  has_many :ai_players
  has_many :user_games
  has_many :users, through: :user_games

  def add_players
    players = AiPlayer.first(Game.last.player_count - 1)
    players.each { |player| Game.last.ai_players << player }
  end

  def set_blinds

    user = Game.last.users.first
    new_cash_amount = user.cash - little_blind
    user.update(cash: new_cash_amount)
    ai_player = Game.last.ai_players.first
    new_cash_amount = ai_player.cash - big_blind
    ai_player.update(cash: new_cash_amount)
  end
end
