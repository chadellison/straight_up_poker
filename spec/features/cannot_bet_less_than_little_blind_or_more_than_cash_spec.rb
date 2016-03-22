require "rails_helper"

RSpec.feature "user cannot bet less than little blind or more than total cash" do
  scenario "user sees appropriate message" do
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
    # binding.pry
    click_on "Play Poker"

    click_button "Bet / Raise"
    expect(page).to have_content "How much would you like to bet?"
    fill_in "Current bet", with: "90"
    click_on "Submit"
    expect(page).to have_content "You cannot bet less than the little blind or more than you have"
    expect(current_path).to eq game_path(Game.last.id)

    click_button "Bet / Raise"
    fill_in "Current bet", with: "150"
    click_on "Submit"

    click_on "Deal Flop"

    click_button "Bet / Raise"
    fill_in "Current bet", with: "10000"
    click_on "Submit"

    expect(page).to have_content "You cannot bet less than the little blind or more than you have"
    expect(current_path).to eq game_path(Game.last.id)
    click_button "Bet / Raise"
    fill_in "Current bet", with: "200"
    click_on "Submit"
    expect(current_path).to eq game_path(Game.last.id)
  end
end
