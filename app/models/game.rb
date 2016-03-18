class Game
  # has_many :ai_players
  # has_many :user_games
  # has_many :cards
  # has_many :users, through: :user_games

  attr_reader :player_count, :little_blind, :big_blind, :ai_players, :pocket_cards, :flop_cards, :cards, :turn_card, :river_card, :flop, :turn, :river
  attr_accessor :user, :winner, :pot

  def initialize(player_count = 2, little_blind = 50)
    @winner
    @player_count = player_count
    @little_blind = little_blind
    @big_blind = little_blind * 2
    @ai_players = []
    @user = []
    @cards = []
    @flop_cards = []
    @turn_card
    @river_card
    @pocket_cards = false
    @flop = false
    @turn = false
    @river = false
    @pot = 0
  end

  def set_up_game
    add_players
    set_blinds
    load_deck
    deal_pocket_cards(ai_players)
    deal_pocket_cards(users)
  end

  def add_players
    players = AiPlayer.first(player_count - 1)
    players.each { |player| @ai_players << player }
  end

  def set_blinds
    user.last.bet(little_blind)
    ai_players.first.bet(big_blind)
    pot = little_blind + big_blind
  end

  def load_deck
    values = (2..10).to_a + ["Ace", "King", "Queen", "Jack"]
    suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    values.each do |value|
      suits.each do |suit|
        cards << Card.new(value, suit)
      end
    end
  end

  def deal_pocket_cards(players)
    player_cards = []
    players.each do |player|
      2.times { player_cards << cards.shuffle!.pop.present_card }
      player.update(cards: player_cards)
    end
  end

  def deal_flop
    burn_card
    3.times do
      flop_cards << cards.shuffle!.pop
    end
  end

  def deal_turn
    burn_card
    @turn_card = cards.shuffle!.pop
  end

  def deal_river
    burn_card
    @river_card = cards.shuffle!.pop
  end

  def burn_card
    burn = cards.pop
  end

  def present_flop
    flop_cards.map do |card|
      card.present_card
    end.join(", ")
  end

  def present_turn
    turn_card.present_card
  end

  def present_river
    river_card.present_card
  end


  def user_action(action, amount = nil)
    if action == "call"
      call_amount = ai_players.maximum(:total_bet)
      bet_amount = call_amount - user.total_bet
      user.bet(bet_amount)
    elsif action == "bet"
      #pot += amount
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
      # math for this...
      #for multiple ai_players consider a loop that has an ai take an action based on attributes
    elsif user_action == "call" || "check"
      ai_players.last.check
    end
  end

  def game_action
    if flop_cards.empty?
      deal_flop
    elsif turn_card.nil?
      deal_turn
    elsif river_card_id.nil?
      deal_river
    else
      update(winner: determine_winner)
    end
  end

  def game_cards
    flop_cards + [turn_card, river_card]
  end

  def determine_winner
    players = {}
    ai_players.each do |ai_player|
      players[ai_player.name] = ai_player.cards + game_cards
    end

    players[user.name] = user.cards + game_cards
    CardAnalyzer.new.determine_winner(players)
  end

  def update_game
    if !pocket_cards
      @pocket_cards = true
    elsif pocket_cards && !flop
      @flop = true
    elsif flop && !turn
      @turn = true
    else #make conditional for fold
      @river = true
    end
  end
end
