# require "rails_helper"
#
# class CardAnalyzerTest < MiniTest::Test
#   def test_high_card
#     cards = [
#       Card.new(10, :diamonds),
#       Card.new(7, :hearts),
#       Card.new(2, :hearts)
#     ]
#
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal HighCard, card_analyzer.hand.class
#
#     pair = [
#       Card.new(3, :clubs),
#       Card.new(3, :hearts)
#     ]
#     card_analyzer2 = CardAnalyzer.new(pair)
#     refute card_analyzer2.hand.class == HighCard
#   end
#
#   def test_pair
#     cards = [
#       Card.new(2, :diamonds),
#       Card.new(2, :hearts)
#     ]
#
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal TwoOfKind, card_analyzer.hand.class
#   end
#
#   def test_two_pair
#     cards = [
#       Card.new(7, :clubs),
#       Card.new(3, :clubs),
#       Card.new(7, :hearts),
#       Card.new(2, :clubs),
#       Card.new(3, :clubs)
#     ]
#
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal TwoPair, card_analyzer.hand.class
#   end
#
#   def test_three_of_a_kind
#     cards = [
#       Card.new(2, :diamonds),
#       Card.new(2, :hearts),
#       Card.new(2, :clubs)
#     ]
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal ThreeOfKind, card_analyzer.hand.class
#   end
#
#   def test_straight
#     cards = [
#       Card.new(5, :hearts),
#       Card.new(6, :clubs),
#       Card.new(9, :diamonds),
#       Card.new(3, :hearts),
#       Card.new(8, :spades),
#       Card.new(7, :spades),
#       Card.new(2, :spades)
#     ]
#
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal Straight, card_analyzer.hand.class
#   end
#
#   def test_straight_with_face_cards
#     cards = [
#       Card.new(9, :clubs),
#       Card.new(10, :hearts),
#       Card.new("Jack", :hearts),
#       Card.new("King", :hearts),
#       Card.new("Queen", :spades)
#     ]
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal Straight, card_analyzer.hand.class
#
#   end
#
#   def test_ace_low_straight
#     cards = [
#       Card.new("Ace", :clubs),
#       Card.new(3, :hearts),
#       Card.new(5, :hearts),
#       Card.new(4, :hearts),
#       Card.new(2, :spades)
#     ]
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal Straight, card_analyzer.hand.class
#
#   end
#
#   def test_ace_high_straight
#     cards = [
#       Card.new("Ace", :clubs),
#       Card.new(10, :hearts),
#       Card.new("Jack", :hearts),
#       Card.new("King", :spades),
#       Card.new("King", :hearts),
#       Card.new("Queen", :spades),
#     ]
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal Straight, card_analyzer.hand.class
#   end
#
#   def test_flush
#     cards = [
#       Card.new(5, :clubs),
#       Card.new(3, :clubs),
#       Card.new(7, :clubs),
#       Card.new(3, :clubs),
#       Card.new(3, :clubs)
#     ]
#
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal Flush, card_analyzer.hand.class
#   end
#
#   def test_full_house
#     cards = [
#       Card.new(2, :diamonds),
#       Card.new(2, :hearts),
#       Card.new(2, :clubs),
#       Card.new(3, :hearts),
#       Card.new(3, :clubs)
#     ]
#
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal FullHouse, card_analyzer.hand.class
#   end
#
#
#
#   def test_four_of_kind
#     cards = [
#       Card.new(5, :hearts),
#       Card.new(5, :clubs),
#       Card.new(5, :diamonds),
#       Card.new(7, :hearts),
#       Card.new(5, :spades)
#     ]
#
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal FourOfKind, card_analyzer.hand.class
#
#   end
#
#   def test_straight_flush
#     cards = [
#       Card.new(9, :clubs),
#       Card.new(8, :clubs),
#       Card.new(7, :clubs),
#       Card.new(6, :clubs),
#       Card.new(10, :clubs)
#     ]
#
#     card_analyzer = CardAnalyzer.new(cards)
#     assert_equal StraightFlush, card_analyzer.hand.class
#   end
#
#   def test_royal_flush
#     cards = [
#       Card.new("King", :clubs),
#       Card.new("Ace", :clubs),
#       Card.new("Queen", :clubs),
#       Card.new("Jack", :clubs),
#       Card.new(10, :clubs)
#     ]
#
#     card_analyzer = CardAnalyzer.new(cards)
#     refute card_analyzer.hand.class == StraightFlush
#     assert_equal RoyalFlush, card_analyzer.hand.class
#   end
# end
