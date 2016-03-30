class Game < ActiveRecord::Base
  has_many :ai_players
  has_many :users

  def set_up_game(current_user)
    current_user.update(round: 0)
    add_players(current_user)
    set_blinds
    load_deck
    deal_pocket_cards(find_players)
  end

  def find_range
    if users.last.folded == true
      find_players.reject { |player| player.class == User }
    elsif user_index == 1
      find_players[2..-1] + find_players[0...user_index]
    elsif user_index == 0
      find_players[2..-1]
    else
      find_players[(user_index + 1)..-1] || find_players[2...user_index]
    end
  end

  def user_index
    users.last.round % find_players.length
  end

  def initial_actions
    player_actions = find_range.map do |player|
      player.update(action: true)
      player.take_action
    end.join("\n")
  end

  def add_players(user)
    users << user.refresh
    players = AiPlayer.first(player_count - 1)
    players.each { |player| ai_players << player.refresh }
  end

  def set_blinds
    find_players[0].bet(little_blind)
    find_players[1].bet(big_blind)
  end

  def load_deck
    values = (2..10).to_a + ["Ace", "King", "Queen", "Jack"]
    suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    values.each do |value|
      suits.each do |suit|
        cards << Card.new(value, suit).present_card
      end
    end
    update(cards: cards)
  end

  def find_players
    (users + ai_players.order(:name)).rotate(users.last.round * -1)
  end

  def deal_flop
    flop_cards = []
    burn_card
    3.times do
      flop_cards << cards.shuffle!.pop
    end
    update(flop_cards: flop_cards)
    update(cards: cards)
  end

  def deal_turn
    burn_card
    turn_card = cards.shuffle!.pop
    update(turn_card: turn_card)
    update(cards: cards)
  end

  def deal_river
    burn_card
    river_card = cards.shuffle!.pop
    update(river_card: river_card)
    update(cards: cards)
  end

  def burn_card
    cards.pop
  end

  def deal_pocket_cards(players)
    players.each do |player|
      pocket_cards = []
      2.times { pocket_cards << cards.shuffle!.pop }
      player.update(cards: pocket_cards)
      update(cards: cards)
    end
  end

  def user_action(action, amount = nil)
    user = users.last
    if action == "call"
      bet_amount = highest_bet - user.total_bet
      user.bet(bet_amount)
    elsif action == "bet"
      user.bet(amount[:current_bet])
    elsif action == "fold"
      user.fold
    end
  end

  def ai_action(user_action = nil, amount = nil)
    ai_players.each do |player|
      player.update(action: false) if highest_bet > player.total_bet
    end

    find_players.select do |player|
      player.action == false
    end.map do |player|
      player.update(action: true)
      player.take_action(user_action, amount)
    end.join("\n")
  end

  def highest_bet
    if ai_players.maximum(:total_bet) > users.maximum(:total_bet)
      ai_players.maximum(:total_bet)
    else
      users.maximum(:total_bet)
    end
  end

  def game_action
    if flop_cards.empty?
      deal_flop
    elsif !turn_card
      deal_turn
    elsif !river_card
      deal_river
    else
      update(winner: determine_winner) unless winner
    end
    ai_players.each { |player| player.update(action: false) }
    update_game if users.last.folded == true
  end

  def game_cards
    flop_cards + [turn_card, river_card]
  end

  def determine_winner
    players = {}
    user = [] if users.last.folded == true
    user = users if users.last.folded == false
    # all_players = find_players.reject { |player| player.folded == true }
    #players
    (ai_players + user).each do |player|
      players[player] = player.cards + game_cards
    end
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

  def refresh
    update(
                           winner: nil,
                           bets: nil,
                           hands: nil,
                           pocket_cards: false,
                           flop: false,
                           turn: false,
                           river: false,
                           pot: 0,
                           cards: [],
                           flop_cards: [],
                           turn_card: nil,
                           river_card: nil
                           )

    find_players.each { |player| player.refresh }
    load_deck
    users.last.update(round: users.last.round + 1)
    set_blinds
    deal_pocket_cards(find_players)
  end
end
