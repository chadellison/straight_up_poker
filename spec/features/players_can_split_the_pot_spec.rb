require "rails_helper"

RSpec.feature "players can split the pot" do
  scenario "player sees the winners and their hands" do
    User.create(name: "jones", username: "jones", password: "password")
    oscar = AiPlayer.create(name: "Oscar")
    zoie = AiPlayer.create(name: "Zoie")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_on "Login"

    expect(page).to have_content "Welcome jones"

    click_on "Play"

    select "3", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    click_on "Call"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"
    click_on "Check"

    expect(Game.last.pot).to eq 600

    ace = Card.new("Ace", "Spades").present_card
    ace2 = Card.new("Ace", "Hearts").present_card

    two = Card.new("2", "Hearts").present_card
    three = Card.new("3", "Hearts").present_card

    five = Card.new("5", "Clubs").present_card
    seven = Card.new("7", "Spades").present_card

    ace = Card.new("Ace", "Clubs").present_card
    king = Card.new("King", "Spades").present_card
    king2 = Card.new("King", "Diamonds").present_card

    turn = Card.new("5", "Clubs").present_card
    river = Card.new("9", "Diamonds").present_card

    User.last.update(cards: [ace, two])
    oscar.update(cards: [ace2, three])
    zoie.update(cards: [five, seven])

    Game.last.update(flop_cards: [ace, king, king2])
    Game.last.update(turn_card: turn)
    Game.last.update(river_card: river)
    expect(User.last.cash).to eq 800

    click_on "Show Winner"

    expect(page).to have_content "jones and Oscar split the pot with Two Pairs!"
    expect(Game.last.pot).to eq 600
    expect(User.last.cash).to eq 1100

    click_on "Continue"

    expect(User.last.cash).to eq 900
  end
end
