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
    click_button "Login"

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

    ace = ["ACE", "Spades"]
    ace2 = ["ACE", "Hearts"]

    two = ["2", "Hearts"]
    three = ["3", "Hearts"]

    five = ["5", "Clubs"]
    seven = ["7", "Spades"]

    ace = ["ACE", "Clubs"]
    king = ["KING", "Spades"]
    king2 = ["KING", "Diamonds"]

    turn = ["5", "Clubs"]
    river = ["9", "Diamonds"]

    User.last.update(cards: [ace, two])
    oscar.update(cards: [ace2, three])
    zoie.update(cards: [five, seven])

    Game.last.update(flop_cards: [ace, king, king2])
    Game.last.update(turn_card: turn)
    Game.last.update(river_card: river)
    expect(User.last.cash).to eq 1800

    click_on "Show Winner"

    expect(page).to have_content "jones and Oscar split the pot with Two Pairs!"
    expect(Game.last.pot).to eq 600
    expect(User.last.cash).to eq 2100

    click_on "Continue"

    expect(User.last.cash).to eq 1900
  end
end
