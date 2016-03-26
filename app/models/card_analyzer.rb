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
    # player_hands.min_by do |player, hand|
    #   hand = make_card_objects(hand)
    #   HANDS.index(find_hand(hand).class) #this needs to handle ties and hands that are the same
    # end.first.take_winnings
    all_players = player_hands.sort_by do |player, hand|
      hand = make_card_objects(hand)
      HANDS.index(find_hand(hand).class) #this needs to handle ties and hands that are the same
    end
    best_hands = all_players.map do |player_hand|
      hand = make_card_objects(player_hand.last)
      [player_hand.first, hand]
    end
    best_hands = best_hands.select do |player_hand|
      HANDS.index(find_hand(player_hand.last).class) == HANDS.index(find_hand(best_hands.first.last).class)
    end

    if best_hands.size == 1
      best_hands.first.first.take_winnings
    else
      best_hands = best_hands.map do |player_hand|
        # hand = make_card_objects(player_hand.last)
        # binding.pry
        hand = card_converter(player_hand.last).sort_by(&:value)
        [player_hand.first, hand] #find_best(hand)] <-- make this method
      end.sort_by do |best_hand|
        best_hand.last.last.value
      end.last.first.take_winnings #this needs to handle ties
    end
  end

  def make_card_objects(cards)
    cards.map do |card|
      Card.new(card.split.first, card.split.last)
    end
  end

  def card_converter(cards)
    cards.map do |card|
      case card.value
      when "Ace"
        ace_low?(cards) ? Card.new(1, card.suit) : Card.new(14, card.suit)
      when "King"
        Card.new(13, card.suit)
      when "Queen"
        Card.new(12, card.suit)
      when "Jack"
        Card.new(11, card.suit)
      else
        Card.new(card.value.to_i, card.suit)
      end
    end
  end

  def ace_low?(cards)
    card_values = cards.map { |card| card.value.to_i }
    [card_values.include?(2),
      card_values.include?(3),
      card_values.include?(4),
      card_values.include?(5)].all?
  end
  # make tests for analyzing the same kinds of hands

  # 1 determine what kind of hand it is
  # 2 sort that hand by its values
  # 3 select only those cards necessary to retain that hand
  # 4 compare the last card across different hands to see which is highest
end
