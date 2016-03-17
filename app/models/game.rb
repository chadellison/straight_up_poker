class Game < ActiveRecord::Base
  has_many :ai_players
  has_many :user_games
  has_many :cards
  has_many :users, through: :user_games

  def set_up_game
    add_players
    set_blinds
    load_deck
    deal_pocket_cards(ai_players)
    deal_pocket_cards(users)
  end

  def add_players
    players = AiPlayer.first(Game.last.player_count - 1)
    players.each { |player| Game.last.ai_players << player }
  end

  def set_blinds
    users.last.bet(little_blind)
    ai_players.first.bet(big_blind)
  end

  def load_deck
    Card.all.each do |card|
      cards << card
    end
  end

  def deal_flop
    flop_cards = []
    burn_card
    3.times do
      flop_cards << cards.sample.id
      cards.delete(flop_cards.last)
    end
    update(flop_card_ids: flop_cards)
  end

  def deal_turn
    burn_card
    turn_id = cards.sample.id
    cards.delete(turn_id)
    update(turn_card_id: turn_id)
  end

  def deal_river
    burn_card
    river_id = cards.sample.id
    cards.delete(river_id)
    update(river_card_id: river_id)
  end

  def burn_card
    burn = cards.sample.id
    cards.delete(burn)
  end

  def present_flop
    flop_card_ids.map do |card_id|
      Card.find(card_id).present_card
    end.join(", ")
  end

  def present_turn
    Card.find(turn_card_id).present_card
  end

  def present_river
    Card.find(river_card_id).present_card
  end

  def deal_pocket_cards(players)
    players.each do |player|
      2.times { player.cards << cards.sample }
      cards.delete(player.cards.first.id)
      cards.delete(player.cards.last.id)
    end
  end

  def user_action(action, amount = nil)
    user = users.last
    if action == "call"
      call_amount = ai_players.maximum(:total_bet)
      bet_amount = call_amount - user.total_bet
      user.bet(bet_amount)
    elsif action == "bet"
      user.bet(amount[:current_bet])
    elsif action == "fold"
      user.fold
    end
  end

  def ai_action(user_action, amount = nil)
    if user_action == "fold"
      ai_players.last.make_snarky_remark
    elsif user_action == "bet"
      ai_players.last.call
      #for multiple ai_players consider a loop that has an ai take an action based on attributes
    elsif user_action == "call" || "check"
      ai_players.last.check
    end
  end

  def game_action
    if flop_card_ids.empty?
      deal_flop
    elsif !turn_card_id
      deal_turn
    elsif !river_card_id
      deal_river
    else
      update(winner: determine_winner)
    end
  end

  def game_cards
    cards = flop_card_ids.map do |id|
      Card.find(id)
    end

    cards << Card.find(turn_card_id)
    cards << Card.find(river_card_id)
  end

  def determine_winner
    players = {}
    ai_players.each do |ai_player|
      players[ai_player.name] = ai_player.cards + game_cards
    end

    players[users.last.name] = users.last.cards + game_cards
    CardAnalyzer.new.determine_winner(players)
  end

  def update_game
    if !pocket_cards
      update(pocket_cards: true)
    elsif pocket_cards && !flop
      update(flop: true)
    elsif flop && !turn
      update(turn: true)
    else #make conditional for fold
      update(river: true)
    end
  end
end
