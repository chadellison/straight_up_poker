require "rails_helper"

RSpec.feature "users sees game info" do
  scenario "users sees game stats for each stage of the game" do
    AiPlayer.create(name: "Mary")
    AiPlayer.create(name: "Frank")
    User.create(name: "jones", username: "jones", password: "password")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_on "Login"

    click_on "Play"

    select "3", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"
    expect(page).to have_content "Little Blind: jones, $100.00"
    expect(page).to have_content "Big Blind: Mary, $200.00"

    expect(page).to have_content "Pot: $500"
    expect(page).to have_content "Mary: $800.00"
    expect(page).to have_content "Frank: $800.00"
  end
end
