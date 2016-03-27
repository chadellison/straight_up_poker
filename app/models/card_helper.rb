module CardHelper
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

  def find_best(cards)
    sorted_cards = card_converter(cards).sort_by(&:value)
    hand = find_hand(cards).class
    return [cards.last] if hand == HighCard
    best_cards = sorted_cards.select do |card|
      find_hand(sorted_cards.reject { |match| match == card }).class != hand
    end.reverse
    remaining = sorted_cards.reject { |card| best_cards.map(&:value).include?(card.value)}.reverse
    (best_cards + remaining)[0..4]
  end

  def make_card_objects(cards)
    cards.map do |card|
      Card.new(card.split.first, card.split.last)
    end
  end
end
