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
      Card.new("JACK", "hearts"),
      Card.new("KING", "hearts"),
      Card.new("QUEEN", "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines an ace low straight" do
    cards = [
      Card.new("ACE", "clubs"),
      Card.new("3", "hearts"),
      Card.new("5", "hearts"),
      Card.new("4", "hearts"),
      Card.new("2", "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines an ace high straight" do
    cards = [
      Card.new("ACE", "clubs"),
      Card.new("10", "hearts"),
      Card.new("JACK", "hearts"),
      Card.new("KING", "spades"),
      Card.new("KING", "hearts"),
      Card.new("QUEEN", "spades"),
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
      Card.new("JACK", "clubs"),
      Card.new("QUEEN", "clubs")
    ]

    expect(CardAnalyzer.new.find_hand(not_a_straight_flush).class).not_to eq StraightFlush
    expect(CardAnalyzer.new.find_hand(not_a_straight_flush).class).to eq Flush
  end

  it "determines a royal flush" do
    cards = [
      Card.new("KING", "clubs"),
      Card.new("ACE", "clubs"),
      Card.new("QUEEN", "clubs"),
      Card.new("JACK", "clubs"),
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
      ["5", "Clubs", "image"],
      ["4", "Clubs", "image"],
      ["QUEEN", "Diamonds", "image"],
      ["7", "Spades", "image"],
      ["10", "Clubs", "image"],
      ["2", "Hearts", "image"],
      ["3", "Hearts", "image"]
    ]

    player2_cards = [
      ["KING", "Clubs", "image"],
      ["5", "Clubs", "image"],
      ["QUEEN", "Diamonds", "image"],
      ["7", "Spades", "image"],
      ["10", "Clubs"],
      ["2", "Hearts", "image"],
      ["3", "Hearts"]
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
      ["5", "Clubs", "image"],
      ["5", "Hearts", "image"],
      ["QUEEN", "Diamonds", "image"],
      ["7", "Spades", "image"],
      ["10" "Clubs", "image"],
      ["2", "Hearts", "image"],
      ["3", "Hearts", "image"]
    ]

    player2_cards = [
      ["QUEEN", "Clubs", "image"],
      ["5", "spades", "image"],
      ["QUEEN", "Diamonds", "image"],
      ["7", "Spades", "image"],
      ["10", "Clubs", "image"],
      ["2", "Hearts", "image"],
      ["3" "Hearts", "image"]
    ]

    player3_cards = [
      ["KING", "Clubs", "image"],
      ["3", "Clubs", "image"],
      ["QUEEN", "Diamonds", "image"],
      ["7", "Spades", "image"],
      ["10", "Clubs", "image"],
      ["2", "Hearts", "image"],
      ["3", "Hearts", "image"]
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
      ["2", "Clubs"],
      ["3", "Clubs"],
      ["QUEEN", "Diamonds"],
      ["7", "Spades"],
      ["10", "Clubs"],
      ["2", "Hearts"],
      ["3", "Hearts"]
    ]

    player2_cards = [
      ["QUEEN", "Clubs"],
      ["3", "Spades"],
      ["QUEEN", "Diamonds"],
      ["7", "Spades"],
      ["10", "Clubs"],
      ["2", "Hearts"],
      ["3", "Hearts"]
    ]

    player3_cards = [
      ["7", "Clubs"],
      ["3", "Diamonds"],
      ["QUEEN", "Diamonds"],
      ["7", "Spades"],
      ["10", "Clubs"],
      ["2", "Hearts"],
      ["3", "Hearts"]
    ]
    two_pair_winner = CardAnalyzer.new
    winner = two_pair_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{jannet.id} ai_player").to eq winner
  end

  it "determines the winner between same two pair" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      ["QUEEN", "Hearts"],
      ["3", "Clubs"],
      ["QUEEN", "Diamonds"],
      ["7", "Spades"],
      ["9", "Clubs"],
      ["2", "Hearts"],
      ["3", "Hearts"]
    ]

    player2_cards = [
      ["QUEEN", "Clubs"],
      ["3", "Spades"],
      ["QUEEN", "Spades"],
      ["7", "Spades"],
      ["10", "Clubs"],
      ["2", "Hearts"],
      ["3", "Hearts"]
    ]

    player3_cards = [
      ["7", "Clubs"],
      ["3", "Diamonds"],
      ["5", "Diamonds"],
      ["7", "Spades"],
      ["10", "Clubs"],
      ["2", "Hearts"],
      ["3", "Hearts"]
    ]

    two_pair_winner = CardAnalyzer.new
    winner = two_pair_winner.determine_winner({
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
      ["2", "Clubs"],
      ["3", "Clubs"],
      ["QUEEN", "Diamonds"],
      ["3", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["3", "Hearts"]
    ]

    player2_cards = [
      ["ACE", "Clubs"],
      ["3", "Diamonds"],
      ["QUEEN", "Diamonds"],
      ["3", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["3", "Hearts"]
    ]

    player3_cards = [
      ["9", "Spades"],
      ["9", "Clubs"],
      ["QUEEN", "Diamonds"],
      ["3", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["3", "Hearts"]
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
      ["ACE", "Clubs"],
      ["3", "Diamonds"],
      ["QUEEN", "Diamonds"],
      ["3", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["3", "Hearts"]
    ]

    player2_cards = [
      ["2", "Clubs"],
      ["3", "Clubs"],
      ["QUEEN", "Diamonds"],
      ["3", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["3", "Hearts"]
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
      ["KING", "Clubs"],
      ["KING", "Diamonds"],
      ["QUEEN", "Diamonds"],
      ["ACE", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["ACE", "Hearts"]
    ]

    player2_cards = [
      ["KING", "Clubs"],
      ["ACE", "Diamonds"],
      ["QUEEN", "Diamonds"],
      ["ACE", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["ACE", "Hearts"]
    ]
    player3_cards = [
      ["2", "Clubs"],
      ["ACE", "Clubs"],
      ["QUEEN", "Diamonds"],
      ["ACE", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["ACE", "Hearts"]
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
      ["7", "Clubs"],
      ["8", "Diamonds"],
      ["QUEEN", "Diamonds"],
      ["ACE", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["JACK", "Hearts"]
    ]

    player2_cards = [
      ["KING", "Clubs"],
      ["JACK", "Diamonds"],
      ["QUEEN", "Diamonds"],
      ["8", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["JACK", "Hearts"]
    ]
    player3_cards = [
      ["2", "Clubs"],
      ["ACE", "Clubs"],
      ["QUEEN", "Diamonds"],
      ["3", "Spades"],
      ["10", "Clubs"],
      ["5", "Hearts"],
      ["4", "Hearts"]
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
      ["6", "Hearts"],
      ["3", "Hearts"],
      ["QUEEN", "Hearts"],
      ["ACE", "Spades"],
      ["10", "Clubs"],
      ["9", "Hearts"],
      ["JACK", "Hearts"]
    ]

    player2_cards = [
      ["KING", "Diamonds"],
      ["10", "Diamonds"],
      ["QUEEN", "Diamonds"],
      ["8", "Spades"],
      ["10", "Diamonds"],
      ["9", "Diamonds"],
      ["6", "Hearts"]
    ]
    player3_cards = [
      ["2", "Clubs"],
      ["ACE", "Clubs"],
      ["QUEEN", "Diamonds"],
      ["3", "Spades"],
      ["10", "Clubs"],
      ["6", "Clubs"],
      ["4", "Clubs"]
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
      ["6", "Hearts"],
      ["3", "Hearts"],
      ["QUEEN Hearts"],
      ["3", "Spades"],
      ["10", "Clubs"],
      ["3", "Spades"],
      ["6", "Clubs"]
    ]

    player2_cards = [
      ["QUEEN", "Diamonds"],
      ["2", "Diamonds"],
      ["QUEEN", "Diamonds"],
      ["8", "Spades"],
      ["2", "Clubs"],
      ["9", "Diamonds"],
      ["2", "Hearts"]
    ]
    player3_cards = [
      ["9", "Clubs"],
      ["ACE", "Clubs"],
      ["QUEEN", "Diamonds"],
      ["9", "Spades"],
      ["10", "Clubs"],
      ["10", "Hearts"],
      ["10", "Spades"]
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
      ["6", "Hearts"],
      ["6", "Diamonds"],
      ["QUEEN Hearts"],
      ["3", "Spades"],
      ["10", "Clubs"],
      ["6", "Spades"],
      ["6", "Clubs"]
    ]

    player2_cards = [
      ["QUEEN", "Diamonds"],
      ["2", "Diamonds"],
      ["QUEEN", "Clubs"],
      ["8", "Spades"],
      ["2", "Clubs"],
      ["QUEEN", "Spades"],
      ["QUEEN", "Hearts"]
    ]
    player3_cards = [
      ["10", "Clubs"],
      ["ACE", "Clubs"],
      ["QUEEN", "Diamonds"],
      ["9", "Spades"],
      ["10", "Diamonds"],
      ["10", "Hearts"],
      ["10", "Spades"]
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
      ["6", "Hearts"],
      ["5", "Hearts"],
      ["QUEEN Hearts"],
      ["3", "Hearts"],
      ["4", "Hearts"],
      ["ACE", "Hearts"],
      ["2", "Hearts"]
    ]

    player2_cards = [
      ["QUEEN", "Clubs"],
      ["2", "Diamonds"],
      ["JACK", "Clubs"],
      ["10", "Clubs"],
      ["2", "Clubs"],
      ["9", "Clubs"],
      ["8", "Clubs"]
    ]
    player3_cards = [
      ["10", "Spades"],
      ["9", "Spades"],
      ["QUEEN", "Diamonds"],
      ["8", "Spades"],
      ["7", "Spades"],
      ["10", "Hearts"],
      ["6", "Spades"]
    ]

    straight_flush_winner = CardAnalyzer.new
    winner = straight_flush_winner.determine_winner({
      frank => player1_cards,
      jannet => player2_cards,
      bob => player3_cards
      })
    expect("#{jannet.id} ai_player").to eq winner
  end

  it "handles a tie game" do
    game = Game.create
    frank = game.ai_players.create(name: "Frank")
    jannet = game.ai_players.create(name: "Jannet")
    bob = game.ai_players.create(name: "bob")

    player1_cards = [
      ["6", "Hearts"],
      ["5", "Hearts"],
      ["QUEEN Hearts"],
      ["3", "Hearts"],
      ["4", "Hearts"],
      ["ACE", "Hearts"],
      ["2", "Hearts"]
    ]

    player2_cards = [
      ["6", "Clubs"],
      ["5", "Clubs"],
      ["QUEEN Clubs"],
      ["3", "Clubs"],
      ["4", "Clubs"],
      ["10", "Clubs"],
      ["2", "Clubs"]
    ]
    player3_cards = [
      ["2", "Spades"],
      ["4", "Spades"],
      ["QUEEN", "Diamonds"],
      ["9", "Spades"],
      ["5", "Spades"],
      ["3", "Spades"],
      ["6", "Spades"]
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
