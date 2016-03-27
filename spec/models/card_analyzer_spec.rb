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
    expect(CardAnalyzer.new.find_hand(cards).class).to eq StraightFlush
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
      "5 of Clubs",
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
    high_card_winner = CardAnalyzer.new
    winner = high_card_winner.determine_winner({
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

    high_card_winner = CardAnalyzer.new
    winner = high_card_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards
      })
    expect("#{frank.id} ai_player").to eq winner
  end
end
