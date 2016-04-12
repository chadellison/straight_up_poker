require "rails_helper"

RSpec.feature "user only sees call and check when appropraite" do
  def start_game
    visit root_path

    click_on "Login"
    fill_in "Username", with: "oscar"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"
  end

  scenario "user sees call and not check or user sees check and not call" do
    user = User.create(name: "Oscar", username: "oscar", password: "password")
    ai_player = AiPlayer.create(name: "Rosco")

    start_game

    select "2", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    expect(page).not_to have_button "Check"
    expect(page).to have_button "Fold"
    expect(page).to have_button "Bet / Raise"

    click_on "Call"
    click_on "Deal Flop"

    expect(page).to_not have_button "Call"
    expect(page).to have_button "Fold"
    expect(page).to have_button "Bet / Raise"

    click_on "Check"
  end

  scenario "user sees check after they deal the big blind in the second round" do
    user = User.create(name: "Oscar", username: "oscar", password: "password")
    ai_player = AiPlayer.create(name: "Rosco")

    start_game

    select "2", from: "Player count"
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
    click_on "Show Winner"

    click_on "Continue"

    expect(page).to_not have_button("Call")
    expect(page).to have_button("Check")
  end
end
