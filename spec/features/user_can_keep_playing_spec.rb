require "rails_helper"

RSpec.feature "user can keep playing" do
  scenario "user sees a button to continue or quit" do
    user = User.create(name: "Oscar", username: "oscar", password: "password")
    ai_player = AiPlayer.create(name: "Rosco")

    visit root_path

    click_on "Login"
    fill_in "Username", with: "oscar"
    fill_in "Password", with: "password"
    click_on "Login"

    click_on "Play"

    select "2", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    click_on "Call"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_button "Bet / Raise"

    fill_in "Current bet", with: "200"
    click_on "Submit"
    click_on "Deal River"
    click_on "Check"

    click_on "Show Winner"

    expect(Game.last.pot).to eq 800
    expect(page).to have_button "Continue"
    expect(page).to have_button "Quit"

    click_on "Continue"

    expect(Game.last.pot).to eq 0
    expect(Game.last.little_blind).to eq 100
    expect(Game.last.big_blind).to eq 200
    expect(Game.last.player_count).to eq 2
    expect(Game.last.flop_cards).to eq []
    refute Game.last.turn_card
    refute Game.last.river_card
    refute Game.last.flop
    refute Game.last.turn
    refute Game.last.river
    refute Game.last.winner
    expect(Game.last.cards.count).to eq 52
    expect(Game.last)

    click_on "Fold"

    click_on "Quit"

    expect(page).to have_content "Welcome Oscar"
    expect(current_path).to eq dashboard_path
  end
end
