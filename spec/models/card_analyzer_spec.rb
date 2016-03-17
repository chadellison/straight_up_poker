require "rails_helper"

RSpec.describe CardAnalyzer do
  it "determines a high_card" do
    cards = [
      Card.new(value: "10", suit: "diamonds"),
      Card.new(value: "7", suit: "hearts"),
      Card.new(value: "2", suit: "hearts")
    ]

    expect(CardAnalyzer.new.find_hand(cards).class).to eq HighCard

    pair = [
      Card.new(value: "3", suit: "clubs"),
      Card.new(value: "3", suit: "hearts")
    ]
    expect(CardAnalyzer.new.find_hand(pair).class).to_not eq HighCard
  end

  it "determines a pair" do
    cards = [
      Card.new(value: "2", suit: "diamonds"),
      Card.new(value: "2", suit: "hearts")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq TwoOfKind
  end

  it "determins two pair" do
    cards = [
      Card.new(value: "7", suit: "clubs"),
      Card.new(value: "3", suit: "clubs"),
      Card.new(value: "7", suit: "hearts"),
      Card.new(value: "2", suit: "clubs"),
      Card.new(value: "3", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq TwoPair
  end

  it "determines three of a kind" do
    cards = [
      Card.new(value: "2", suit: "diamonds"),
      Card.new(value: "2", suit: "hearts"),
      Card.new(value: "2", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq ThreeOfKind
  end

  it "determines a straight" do
    cards = [
      Card.new(value: "5", suit: "hearts"),
      Card.new(value: "6", suit: "clubs"),
      Card.new(value: "9", suit: "diamonds"),
      Card.new(value: "3", suit: "hearts"),
      Card.new(value: "8", suit: "spades"),
      Card.new(value: "7", suit: "spades"),
      Card.new(value: "2", suit: "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines a straight with face cards" do
    cards = [
      Card.new(value: "9", suit: "clubs"),
      Card.new(value: "10", suit: "hearts"),
      Card.new(value: "Jack", suit: "hearts"),
      Card.new(value: "King", suit: "hearts"),
      Card.new(value: "Queen", suit: "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines an ace low straight" do
    cards = [
      Card.new(value: "Ace", suit: "clubs"),
      Card.new(value: "3", suit: "hearts"),
      Card.new(value: "5", suit: "hearts"),
      Card.new(value: "4", suit: "hearts"),
      Card.new(value: "2", suit: "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines an ace high straight" do
    cards = [
      Card.new(value: "Ace", suit: "clubs"),
      Card.new(value: "10", suit: "hearts"),
      Card.new(value: "Jack", suit: "hearts"),
      Card.new(value: "King", suit: "spades"),
      Card.new(value: "King", suit: "hearts"),
      Card.new(value: "Queen", suit: "spades"),
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines a flush" do
    cards = [
      Card.new(value: "5", suit: "clubs"),
      Card.new(value: "3", suit: "clubs"),
      Card.new(value: "7", suit: "clubs"),
      Card.new(value: "3", suit: "clubs"),
      Card.new(value: "3", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Flush
  end

  it "determines a full house" do
    cards = [
      Card.new(value: "2", suit: "diamonds"),
      Card.new(value: "2", suit: "hearts"),
      Card.new(value: "2", suit: "clubs"),
      Card.new(value: "3", suit: "hearts"),
      Card.new(value: "3", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq FullHouse
  end

  it "determines four of a kind" do
    cards = [
      Card.new(value: "5", suit: "hearts"),
      Card.new(value: "5", suit: "clubs"),
      Card.new(value: "5", suit: "diamonds"),
      Card.new(value: "7", suit: "hearts"),
      Card.new(value: "5", suit: "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq FourOfKind
  end

  it "determines a straight flush" do
    cards = [
      Card.new(value: "9", suit: "clubs"),
      Card.new(value: "8", suit: "clubs"),
      Card.new(value: "7", suit: "clubs"),
      Card.new(value: "6", suit: "clubs"),
      Card.new(value: "10", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq StraightFlush
  end

  it "determines a royal flush" do
    cards = [
      Card.new(value: "King", suit: "clubs"),
      Card.new(value: "Ace", suit: "clubs"),
      Card.new(value: "Queen", suit: "clubs"),
      Card.new(value: "Jack", suit: "clubs"),
      Card.new(value: "10", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to_not eq StraightFlush
    expect(CardAnalyzer.new.find_hand(cards).class).to eq RoyalFlush
  end
end
