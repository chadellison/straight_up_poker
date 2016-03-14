class Game < ActiveRecord::Base
  has_many :ai_players
  has_many :user_games
  has_many :cards
  has_many :users, through: :user_games

  def set_up_game
    add_players
    set_blinds
    load_deck
    deal_pocket_cards
  end

  def add_players
    players = AiPlayer.first(Game.last.player_count - 1)
    players.each { |player| Game.last.ai_players << player }
  end

  def set_blinds
    users.first.bet(little_blind)
    ai_players.first.bet(big_blind)
  end

  def load_deck
    Card.all.each do |card|
      cards << card
    end
  end

  def deal_pocket_cards
    deal_pocket_cards_to_ai
    deal_pocket_cards_to_user
  end

  def deal_pocket_cards_to_ai
    ai_players.each do |ai_player|
      ai_player.cards << cards.sample
      ai_player.cards << cards.sample
      cards.delete(ai_player.cards.first.id)
      cards.delete(ai_player.cards.last.id)
    end
  end

  def deal_pocket_cards_to_user
    users.each do |user|
      user.cards << cards.sample
      user.cards << cards.sample
      cards.delete(user.cards.first.id)
      cards.delete(user.cards.last.id)
    end
  end

  def ai_action
    ai_players.last.check
  end
end
