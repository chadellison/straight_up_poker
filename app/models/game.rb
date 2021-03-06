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

  def user_index
    users.last.round % find_players.length
  end

  def add_players(user)
    users << user.refresh
    players = AiPlayer.first(player_count - 1)
    players.each do |player|
      player.update(cash: buy_in)
      player.update(out: false)
      ai_players << player.refresh
    end
  end

  def set_blinds
    players_left[0].bet(little_blind)
    players_left[1].bet(big_blind)
  end

  def players_left
    players = find_players.reject(&:out)
    if previous_blind &&
       [players[1] == find_previous_player(previous_blind),
        players.last == find_previous_player(previous_dealer_button),
        players.first == find_previous_player(previous_small_blind)].any?
      players = players.rotate(-1)
    end
    players = players.rotate(-1) if previous_blind &&
                                    players[1] == find_previous_player(previous_blind)
    players
  end

  def find_previous_player(player_info)
    if player_info.split.last == "User"
      User.find(player_info.split.first)
    else
      AiPlayer.find(player_info.split.first)
    end
  end

  def load_deck
    cards = CardsService.new.deck_of_cards_hash[:cards].map do |card|
      [card[:value], card[:suit], card[:image]]
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
    turn_card = cards.pop
    update(turn_card: turn_card)
    update(cards: cards)
  end

  def deal_river
    burn_card
    river_card = cards.pop
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
    user.update(action: true)
    case action
    when "call"
      call_amount = highest_bet - user.total_bet
      user.bet(call_amount)
    when "bet"
      return "Error" if check_bet(amount[:current_bet])
      update(raise_count: raise_count + 1)
      call_amount = Game.find(id).highest_bet - Game.find(id).users.last.total_bet
      user.bet(amount[:current_bet].to_i + call_amount)
    when "fold"
      user.fold
    end
  end

  def check_bet(amount)
    amount.to_i > users.last.cash || amount.to_i < little_blind
  end

  def rule_out(players)
    players.reject { |player| player.updated? || player.class == User }
  end

  def respond_to_user
    return take_action(find_players.rotate(user_index)[1..-1]) if user_index == index_raise
    players = post_user_action_range.reject(&:updated?)
    actions = take_action(players)

    unless find_players.all? { |player| player.updated? }
      return (actions += respond_to_raise) if users.last.folded
      if index_raise > user_index
        players = rule_out(find_players[(index_raise + 1)..-1] +
        find_players[0...user_index])
        actions += take_action(players)
      else
        actions += take_action((find_players[(index_raise + 1)...user_index])
        .reject { |p| p.updated? })
      end
    end
    actions
  end

  def ai_action(user_action = nil, amount = nil)
    if user_action
      respond_to_user
    elsif !pocket_cards
      take_action(find_range) unless find_range.empty?
    elsif users.last.folded
      actions = take_action(players_left.reject { |player| player.class == User })
      (actions + respond_to_raise)
    else
      take_action(players_left[0...user_index]) unless players_left.first.is_a? User
    end
  end

  def respond_to_raise
    actions = []
    until players_left.all? { |player| player.updated? } do
      actions += take_action(rule_out(find_players.rotate(index_raise)))
    end
    actions
  end

  def index_raise
    raiser = find_players.max_by { |player| player.total_bet }
    find_players.index(raiser)
  end

  def take_action(players)
    players.map { |player| player.take_action unless player.updated? }.compact
  end

  def find_range
    case players_left.index(users.last)
    when 1
      players_left.rotate(1)[1..-1]
    when 0
      players_left[2..-1]
    else
      players_left[2...(players_left.index(users.last))]
    end
  end

  def post_user_action_range
    find_players.rotate(user_index)[1..-1]
  end

  def highest_bet
    find_players.max_by(&:total_bet).total_bet
  end

  def game_action
    if flop_cards.empty?
      deal_flop
    elsif turn_card.empty?
      deal_turn
    elsif river_card.empty?
      deal_river
    else
      update(winner: determine_winner) unless winner
      update(champion: winner) if players_left.one? { |player| player.cash > 0 }
    end
    find_players.each { |player| player.update(action: false) }
    update(raise_count: 0)
    update_game if users.last.folded
  end

  def game_cards
    flop_cards + [turn_card] + [river_card]
  end

  def determine_winner
    players = {}
    all_players = find_players.reject { |player| player.folded || player.out }
    all_players.each do |player|
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
    else
      update(river: true)
    end
  end

  def format_player_info(index)
    players_left[index].id.to_s + " " +
    players_left[index].class.to_s
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
            turn_card: [],
            river_card: [],
            previous_blind: format_player_info(1),
            previous_dealer_button: format_player_info(-1),
            previous_small_blind: format_player_info(0)
          )

    find_players.each { |player| player.refresh }
    load_deck
    users.last.update(round: users.last.round + 1)
    set_blinds
    deal_pocket_cards(find_players)
  end
end
