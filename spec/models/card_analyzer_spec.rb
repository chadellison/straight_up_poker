require "rails_helper"

RSpec.describe CardAnalyzer do
  it "determines a high_card" do
    cards = [
      Card.new("10", "diamonds"),
      Card.new("7", "hearts"),
      Card.new("2", "hearts")
    ]

    expect(CardAnalyzer.new.find_hand(cards).class).to eq HighCard

    pair = [
      Card.new("3", "clubs"),
      Card.new("3", "hearts")
    ]
    expect(CardAnalyzer.new.find_hand(pair).class).to_not eq HighCard
  end

  it "determines a pair" do
    cards = [
      Card.new("2", "diamonds"),
      Card.new("2", "hearts")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq TwoOfKind
  end

  it "determins two pair" do
    cards = [
      Card.new("7", "clubs"),
      Card.new("3", "clubs"),
      Card.new("7", "hearts"),
      Card.new("2", "clubs"),
      Card.new("3", "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq TwoPair
  end

  it "determines three of a kind" do
    cards = [
      Card.new("2", "diamonds"),
      Card.new("2", "hearts"),
      Card.new("2", "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq ThreeOfKind
  end

  it "determines a straight" do
    cards = [
      Card.new("5", "hearts"),
      Card.new("6", "clubs"),
      Card.new("9", "diamonds"),
      Card.new("3", "hearts"),
      Card.new("8", "spades"),
      Card.new("7", "spades"),
      Card.new("2", "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines a straight with face cards" do
    cards = [
      Card.new("9", "clubs"),
      Card.new("10", "hearts"),
      Card.new("Jack", "hearts"),
      Card.new("King", "hearts"),
      Card.new("Queen", "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines an ace low straight" do
    cards = [
      Card.new("Ace", "clubs"),
      Card.new("3", "hearts"),
      Card.new("5", "hearts"),
      Card.new("4", "hearts"),
      Card.new("2", "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines an ace high straight" do
    cards = [
      Card.new("Ace", "clubs"),
      Card.new("10", "hearts"),
      Card.new("Jack", "hearts"),
      Card.new("King", "spades"),
      Card.new("King", "hearts"),
      Card.new("Queen", "spades"),
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines a flush" do
    cards = [
      Card.new("5", "clubs"),
      Card.new("3", "clubs"),
      Card.new("7", "clubs"),
      Card.new("3", "clubs"),
      Card.new("3", "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Flush
  end

  it "determines a full house" do
    cards = [
      Card.new("2", "diamonds"),
      Card.new("2", "hearts"),
      Card.new("2", "clubs"),
      Card.new("3", "hearts"),
      Card.new("3", "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq FullHouse
  end

  it "determines four of a kind" do
    cards = [
      Card.new("5", "hearts"),
      Card.new("5", "clubs"),
      Card.new("5", "diamonds"),
      Card.new("7", "hearts"),
      Card.new("5", "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq FourOfKind
  end

  it "determines a straight flush" do
    cards = [
      Card.new("9", "clubs"),
      Card.new("8", "clubs"),
      Card.new("7", "clubs"),
      Card.new("6", "clubs"),
      Card.new("10", "clubs")
    ]

    not_a_straight_flush = [
      Card.new("9", "clubs"),
      Card.new("8", "clubs"),
      Card.new("7", "Hearts"),
      Card.new("6", "clubs"),
      Card.new("10", "spades"),
      Card.new("Jack", "clubs"),
      Card.new("Queen", "clubs")
    ]

    expect(CardAnalyzer.new.find_hand(not_a_straight_flush).class).not_to eq StraightFlush
    expect(CardAnalyzer.new.find_hand(not_a_straight_flush).class).to eq Flush
  end

  it "determines a royal flush" do
    cards = [
      Card.new("King", "clubs"),
      Card.new("Ace", "clubs"),
      Card.new("Queen", "clubs"),
      Card.new("Jack", "clubs"),
      Card.new("10", "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to_not eq StraightFlush
    expect(CardAnalyzer.new.find_hand(cards).class).to eq RoyalFlush
  end

  it "determines a winner between two high card hands" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")

    player1_cards = [
      "5 of Clubs",
      "4 of Clubs",
      "Queen Diamonds",
      "7 of Spades",
      "10 of Clubs",
      "2 of Hearts",
      "3 of Hearts"
    ]

    player2_cards = [
      "King of Clubs",
      "5 Clubs",
      "Queen Diamonds",
      "7 of Spades",
      "10 of Clubs",
      "2 of Hearts",
      "3 of Hearts"
    ]
    high_card_winner = CardAnalyzer.new
    expect("#{jannet.id} ai_player").to eq high_card_winner.determine_winner({ frank => player1_cards, jannet => player2_cards })
  end

  it "determines a winner between multiple two of a kind hands" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "5 of Clubs",
      "5 of Hearts",
      "Queen Diamonds",
      "7 of Spades",
      "10 of Clubs",
      "2 of Hearts",
      "3 of Hearts"
    ]

    player2_cards = [
      "Queen of Clubs",
      "5 spades",
      "Queen Diamonds",
      "7 of Spades",
      "10 of Clubs",
      "2 of Hearts",
      "3 of Hearts"
    ]

    player3_cards = [
      "King of Clubs",
      "3 Clubs",
      "Queen Diamonds",
      "7 of Spades",
      "10 of Clubs",
      "2 of Hearts",
      "3 of Hearts"
    ]
    pair_winner = CardAnalyzer.new
    winner = pair_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{jannet.id} ai_player").to eq winner
  end

  it "determines a winner between multiple two pair hands" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "2 of Clubs",
      "3 of Clubs",
      "Queen Diamonds",
      "7 of Spades",
      "10 of Clubs",
      "2 of Hearts",
      "3 of Hearts"
    ]

    player2_cards = [
      "Queen of Clubs",
      "3 Spades",
      "Queen Diamonds",
      "7 of Spades",
      "10 of Clubs",
      "2 of Hearts",
      "3 of Hearts"
    ]

    player3_cards = [
      "7 of Clubs",
      "3 Diamonds",
      "Queen Diamonds",
      "7 of Spades",
      "10 of Clubs",
      "2 of Hearts",
      "3 of Hearts"
    ]
    high_card_winner = CardAnalyzer.new
    winner = high_card_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{jannet.id} ai_player").to eq winner
  end

  it "determines a winner between multiple three of a kind hands" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "2 of Clubs",
      "3 of Clubs",
      "Queen Diamonds",
      "3 of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "3 of Hearts"
    ]

    player2_cards = [
      "Ace of Clubs",
      "3 of Diamonds",
      "Queen Diamonds",
      "3 of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "3 of Hearts"
    ]

    player3_cards = [
      "9 of Spades",
      "9 of Clubs",
      "Queen Diamonds",
      "3 of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "3 of Hearts"
    ]
    high_card_winner = CardAnalyzer.new
    winner = high_card_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{bob.id} ai_player").to eq winner
  end

  it "determines a winner between multiple of the same three of a kind hand" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "Ace of Clubs",
      "3 of Diamonds",
      "Queen Diamonds",
      "3 of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "3 of Hearts"
    ]

    player2_cards = [
      "2 of Clubs",
      "3 of Clubs",
      "Queen Diamonds",
      "3 of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "3 of Hearts"
    ]

    three_of_a_kind_winner = CardAnalyzer.new
    winner = three_of_a_kind_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards
      })
    expect("#{frank.id} ai_player").to eq winner
  end

  it "determines a winner between multiple of the same high three of a kind hand" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "King of Clubs",
      "King of Diamonds",
      "Queen Diamonds",
      "Ace of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "Ace of Hearts"
    ]

    player2_cards = [
      "King of Clubs",
      "Ace of Diamonds",
      "Queen Diamonds",
      "Ace of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "Ace of Hearts"
    ]
    player3_cards = [
      "2 of Clubs",
      "Ace of Clubs",
      "Queen Diamonds",
      "Ace of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "Ace of Hearts"
    ]

    three_of_a_kind_winner = CardAnalyzer.new
    winner = three_of_a_kind_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{jannet.id} ai_player").to eq winner
  end

  it "determines a winner between straights" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "7 of Clubs",
      "8 of Diamonds",
      "Queen Diamonds",
      "Ace of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "Jack of Hearts"
    ]

    player2_cards = [
      "King of Clubs",
      "Jack of Diamonds",
      "Queen Diamonds",
      "8 of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "Jack of Hearts"
    ]
    player3_cards = [
      "2 of Clubs",
      "Ace of Clubs",
      "Queen Diamonds",
      "3 of Spades",
      "10 of Clubs",
      "5 of Hearts",
      "4 of Hearts"
    ]

    straight_winner = CardAnalyzer.new
    winner = straight_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{jannet.id} ai_player").to eq winner
  end

  it "determines a winner between flushes" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "6 of Hearts",
      "3 of Hearts",
      "Queen Hearts",
      "Ace of Spades",
      "10 of Clubs",
      "9 of Hearts",
      "Jack of Hearts"
    ]

    player2_cards = [
      "King of Diamonds",
      "10 of Diamonds",
      "Queen Diamonds",
      "8 of Spades",
      "10 of Diamonds",
      "9 of Diamonds",
      "6 of Hearts"
    ]
    player3_cards = [
      "2 of Clubs",
      "Ace of Clubs",
      "Queen Diamonds",
      "3 of Spades",
      "10 of Clubs",
      "6 of Clubs",
      "4 of Clubs"
    ]

    flush_winner = CardAnalyzer.new
    winner = flush_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{bob.id} ai_player").to eq winner
  end

  it "determines a winner between full houses" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "6 of Hearts",
      "3 of Hearts",
      "Queen Hearts",
      "3 of Spades",
      "10 of Clubs",
      "3 of Spades",
      "6 of Clubs"
    ]

    player2_cards = [
      "Queen of Diamonds",
      "2 of Diamonds",
      "Queen Diamonds",
      "8 of Spades",
      "2 of Clubs",
      "9 of Diamonds",
      "2 of Hearts"
    ]
    player3_cards = [
      "9 of Clubs",
      "Ace of Clubs",
      "Queen Diamonds",
      "9 of Spades",
      "10 of Clubs",
      "10 of Hearts",
      "10 of Spades"
    ]

    full_house_winner = CardAnalyzer.new
    winner = full_house_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{jannet.id} ai_player").to eq winner
  end

  it "determines a winner between multiple four of a kind hands" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "6 of Hearts",
      "6 of Diamonds",
      "Queen Hearts",
      "3 of Spades",
      "10 of Clubs",
      "6 of Spades",
      "6 of Clubs"
    ]

    player2_cards = [
      "Queen of Diamonds",
      "2 of Diamonds",
      "Queen Clubs",
      "8 of Spades",
      "2 of Clubs",
      "Queen of Spades",
      "Queen of Hearts"
    ]
    player3_cards = [
      "10 of Clubs",
      "Ace of Clubs",
      "Queen Diamonds",
      "9 of Spades",
      "10 of Diamonds",
      "10 of Hearts",
      "10 of Spades"
    ]

    four_of_kind_winner = CardAnalyzer.new
    winner = four_of_kind_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{jannet.id} ai_player").to eq winner
  end

  it "determines a winner between straight flushes" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "6 of Hearts",
      "5 of Hearts",
      "Queen Hearts",
      "3 of Hearts",
      "4 of Hearts",
      "Ace of Hearts",
      "2 of Hearts"
    ]

    player2_cards = [
      "Queen of Clubs",
      "2 of Diamonds",
      "Jack Clubs",
      "10 of Clubs",
      "2 of Clubs",
      "9 of Clubs",
      "8 of Clubs"
    ]
    player3_cards = [
      "10 of Spades",
      "9 of Spades",
      "Queen Diamonds",
      "8 of Spades",
      "7 of Spades",
      "10 of Hearts",
      "6 of Spades"
    ]

    straight_flush_winner = CardAnalyzer.new
    winner = straight_flush_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
      # binding.pry
    expect("#{jannet.id} ai_player").to eq winner
  end

  it "handles a tie game" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      "6 of Hearts",
      "5 of Hearts",
      "Queen Hearts",
      "3 of Hearts",
      "4 of Hearts",
      "Ace of Hearts",
      "2 of Hearts"
    ]

    player2_cards = [
      "6 of Clubs",
      "5 of Clubs",
      "Queen Clubs",
      "3 of Clubs",
      "4 of Clubs",
      "10 of Clubs",
      "2 of Clubs"
    ]
    player3_cards = [
      "2 of Spades",
      "4 of Spades",
      "Queen Diamonds",
      "9 of Spades",
      "5 of Spades",
      "3 of Spades",
      "6 of Spades"
    ]
    tie = CardAnalyzer.new
    winner = tie.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{frank.id} ai_player, #{jannet.id} ai_player, #{bob.id} ai_player").to eq winner
  end
end
