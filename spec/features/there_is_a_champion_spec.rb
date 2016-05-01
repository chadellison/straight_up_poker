require "rails_helper"

RSpec.feature "there is a champion" do
  scenario "Champion sees congratulatory message" do
    User.create(username: "jones", name: "jones", password: "password")
    AiPlayer.create(name: "Rosco")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"
    select "2", from: "Player count"
    select "50", from: "Little blind"
    select "100", from: "Big blind"
    click_on "Play Poker"

    Game.last.players_left.last.update(cash: 200)

    click_on "Bet / Raise"
    fill_in "Current bet", with: "200"
    click_on "Submit"

    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"

    Game.last.players_left.last.update(cards: [["2", "Clubs"], ["7", "Hearts"]])

    flop = [["Ace", "Spades"], ["Ace", "Diamonds"], ["Jack", "Clubs"]]
    turn = ["5", "Hearts"]
    river = ["10", "Clubs"]
    Game.last.update(flop_cards: flop, turn_card: turn, river_card: river)
    Game.last.players_left.first.update(cards: [["Ace", "Clubs", "Ace", "Hearts"]])

    click_on "Check"

    click_on "Show Winner"
    expect(page).to have_content "Congratulations jones! You are the champion, and also a hoss beast!"
    expect(page).not_to have_button "Continue"
    click_on "Play Again"
  end
end
