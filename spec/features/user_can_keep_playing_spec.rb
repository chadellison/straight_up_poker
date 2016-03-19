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

    expect(page).to have_button "Continue"
    expect(page).to have_button "Quit"

    click_on "Continue"
    click_on "Fold"

    click_on "Quit"

    expect(page).to have_content "Welcome Oscar"
    expect(current_path).to eq dashboard_path
  end
end
