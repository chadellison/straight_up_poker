require "rails_helper"

RSpec.feature "user can raise or bet" do
  scenario "user sees ai's response to bet" do
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

    click_button "Bet / Raise"
    expect(page).to have_content "How much would you like to bet?"
    fill_in "Current bet", with: "200"
    click_on "Submit"

    expect(page).to have_content "Rosco Calls!"
    expect(User.last.cash).to eq 700
    expect(AiPlayer.last.cash).to eq 700
    expect(Game.last.pot).to eq 600
  end
end
