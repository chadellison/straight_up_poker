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

  # make tests for analyzing the same kinds of hands

  # 1 determine what kind of hand it is
  # 2 sort that hand by its values
  # 3 select only those cards necessary to retain that hand
  # 4 compare the last card across different hands to see which is highest
end
