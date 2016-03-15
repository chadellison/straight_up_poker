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

  def deal_flop
    flop_cards = []
    burn_card
    3.times do
      flop_cards << cards.sample.id
      cards.delete(flop_cards.last)
    end
    update(flop_cards: flop_cards)
  end

  def deal_turn
    burn_card
    turn_id = cards.sample.id
    cards.delete(turn_id)
    update(turn_card: turn_id)
  end

  def burn_card
    burn = cards.sample.id
    cards.delete(burn)
  end

  def present_flop
    flop_cards.map do |card_id|
      Card.find(card_id).present_card
    end.join(", ")
  end

  def present_turn
    Card.find(turn_card).present_card
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

  def user_action(action)
    user = users.last
    if action == "call"
      call_amount = ai_players.maximum(:last_bet)
      bet_amount = call_amount - user.last_bet
      user.bet(bet_amount)
    elsif action == "check"

    end
  end

  def ai_action
    #if user_action == x ...
    ai_players.last.check
  end

  def update_game
    if !pocket_cards
      update(pocket_cards: true)
    elsif pocket_cards && !flop
      update(flop: true)
    elsif flop && !turn
      update(turn: true)
    else
      update(river: true)
    end
  end
end
