require "rails_helper"

RSpec.feature "user can fold vs multiple ais" do
  scenario "user sees the remainder of the game" do
    AiPlayer.create(name: "Mary")
    AiPlayer.create(name: "Frank")
    AiPlayer.create(name: "Rosco")
    User.create(name: "jones", username: "jones", password: "password")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_on "Login"

    click_on "Play"
    select "4", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    click_on "Fold"

    assert Game.last.winner
    expect(page).to have_content "#{User.find(Game.last.winner.split.first).name} wins!"
  end
end
