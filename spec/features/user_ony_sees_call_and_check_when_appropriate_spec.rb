require "rails_helper"

RSpec.feature "user only sees call and check when appropraite" do
  scenario "user sees call and not check or user sees check and not call" do
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
end
