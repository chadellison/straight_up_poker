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
    cards.size > 0
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
  include CardHelper
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
      if sorted_values[1].nil? || sorted_values.first + 1 == sorted_values[1]
        straight << sorted_values.first
      else
        straight = [] if straight.size < 4
      end
      sorted_values.shift
    end
    straight.size > 4
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
  include CardHelper
  # the order of this collection is important. it is in order by hands' values
  HANDS = [RoyalFlush, StraightFlush, FourOfKind, FullHouse, Flush, Straight, ThreeOfKind, TwoPair, TwoOfKind, HighCard]

  def find_hand(cards)
    HANDS
      .map { |hand| hand.new(cards) }
      .detect(&:match?)
  end

  def determine_winner(player_hands)
    all_players = player_hands.map do |player, hand|
      [player, make_card_objects(hand)]
    end.sort_by do |player_hand|
      HANDS.index(find_hand(player_hand.last).class)
    end

    best_hand = all_players.select do |player_hand|
      index_hand(player_hand.last) == index_hand(all_players.first.last)
    end

    if best_hand.size == 1
      best_hand.first.first.take_winnings
    else
      best_hand.map do |player_hand|
        [player_hand.first, find_best(player_hand.last)]
      end.sort_by do |best_cards|
        best_cards.last.map(&:value)
      end.last.first.take_winnings #this needs to handle ties
    end
  end

  def index_hand(cards)
    HANDS.index(find_hand(cards).class)
  end
end
