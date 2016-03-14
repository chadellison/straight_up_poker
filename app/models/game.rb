class Game < ActiveRecord::Base
  has_many :ai_players
  has_many :user_games
  has_many :cards
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

  def load_deck
    Card.all.each do |card|
      cards << card
    end
  end

  def deal_pocket_cards
    ai_players.each do |ai_player|
      ai_player.cards << cards.sample
      ai_player.cards << cards.sample
      cards.delete(ai_player.cards.first.id)
      cards.delete(ai_player.cards.last.id)
    end
    users.each do |user|
      user.cards << cards.sample
      user.cards << cards.sample
      cards.delete(user.cards.first.id)
      cards.delete(user.cards.last.id)
    end
  end
end
