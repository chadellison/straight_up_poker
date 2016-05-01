require "rails_helper"

RSpec.feature "it can handle ties" do
  scenario "user splits the pot" do
    game = Game.create
    user = game.users.create(name: "jones", username: "jones", password: "password")
    oscar = game.ai_players.create(name: "Oscar")
    rosco = game.ai_players.create(name: "Rosco")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

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

    Game.last.update(flop_cards: [["ACE", "Hearts"], ["ACE", "Diamonds"], ["ACE", "Spades"]])
    Game.last.update(turn_card: ["10", "Spades"])
    Game.last.update(river_card: ["7", "Diamonds"])

    User.find(user.id).update(cards: [["ACE", "Spades"], ["3", "Clubs"]])
    AiPlayer.find(oscar.id).update(cards: [["ACE", "Clubs"], ["10", "Hearts"]])
    AiPlayer.find(rosco.id).update(cards: [["6", "Diamonds"], ["10", "Diamonds"]])

    click_on "Show Winner"

    expect(page).to have_content "jones and Oscar split the pot"
    expect(page).to have_content "jones: ACE of Spades, 3 of Clubs, Oscar: ACE of Clubs, 10 of Hearts"
  end
end
