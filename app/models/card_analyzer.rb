class Flush
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards.group_by(&:suit)
    .values.any? { |suits| suits.size > 4 }
  end
end

class FourOfKind
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards
      .group_by(&:value)
      .values.any? { |cards| cards.size == 4 }
  end
end

class FullHouse
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    [ThreeOfKind.new(cards), TwoOfKind.new(cards)].all?(&:match?)
  end
end

class HighCard
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards.size > 1
  end
end

class RoyalFlush
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    potential_royal = cards.group_by(&:suit)

    cards = potential_royal.values.max_by do |cards|
      cards.size
    end.map(&:value)

    ["Ace", "King", "Queen", "Jack", "10"].all? do |value|
      cards.include?(value)
    end
  end
end

class StraightFlush
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    [Flush.new(cards), Straight.new(cards)].all?(&:match?)
  end
end

class Straight
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    straight = []
    sorted_values = card_converter(cards).sort_by do |card|
      card.value.to_i
    end.map(&:value).uniq

    while sorted_values.size > 0 do
      if sorted_values[1].nil? || sorted_values.first.to_i + 1 == sorted_values[1].to_i
        straight << sorted_values.first
      else
        straight = [] if straight.size < 4
      end
      sorted_values.shift
    end
    straight.size > 4
  end

  def card_converter(cards)
    cards.map do |card|
      case card.value
      when "Ace"
        ace_low? ? Card.new(1, card.suit) : Card.new(14, card.suit)
      when "King"
        Card.new(13, card.suit)
      when "Queen"
        Card.new(12, card.suit)
      when "Jack"
        Card.new(11, card.suit)
      else
        card
      end
    end
  end

  def ace_low?
    card_values = cards.map { |card| card.value.to_i }
    [card_values.include?(2),
      card_values.include?(3),
      card_values.include?(4),
      card_values.include?(5)].all?
  end
end

class ThreeOfKind
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards
      .group_by(&:value)
      .values.any? { |cards| cards.size == 3 }
  end
end

class TwoOfKind
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards
      .group_by(&:value) # {4 => [cards1, cards2]}
      .values.any? { |cards| cards.size == 2 }
  end
end

class TwoPair
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards.group_by(&:value)
    .values.select { |values| values.size == 2 }.size > 1
  end
end

class CardAnalyzer
  # the order of this collection is important. it is in order by hands' values
  HANDS = [RoyalFlush, StraightFlush, FourOfKind, FullHouse, Flush, Straight, ThreeOfKind, TwoPair, TwoOfKind, HighCard]

  def find_hand(cards)
    HANDS
      .map { |hand| hand.new(cards) }
      .detect(&:match?)
  end

  def determine_winner(player_hands)
    winner = player_hands.min_by do |player, hand|
      hand = make_card_objects(hand)
      HANDS.index(find_hand(hand).class) #this needs to handle ties and hands that are the same
    end

    if winner.first.last == AiPlayer
      ai_player = [Game.last.ai_players.find(winner.first.first)].first
      ai_player.take_winnings
    else
      user = [Game.last.users.find(winner.first.first)]
      user.first.take_winnings
    end
  end

  def make_card_objects(cards)
    cards.map do |card|
      Card.new(card.split.first, card.split.last)
    end
  end
end
