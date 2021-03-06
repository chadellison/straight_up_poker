require "rails_helper"

RSpec.feature "user can fold" do
  scenario "user looses the game" do
    User.create(name: "Jones", username: "jones", password: "password")
    AiPlayer.create(name: "Rosco")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"
    select "2", from: "Player count"
    select "75", from: "Little blind"
    select "150", from: "Big blind"
    click_on "Play Poker"
    expect(Game.last.pot).to eq 225
    click_on "Fold"
    expect(AiPlayer.find(Game.last.winner.split.first).name).to eq "Rosco"
  end
end
