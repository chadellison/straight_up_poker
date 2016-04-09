require "rails_helper"

RSpec.feature "user can fold vs multiple ais" do
  scenario "user sees the remainder of the game" do
    AiPlayer.create(name: "Frank")
    AiPlayer.create(name: "Mary")
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

    refute Game.last.winner

    click_on "Fold"
    expect(page).to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks Rosco Checks"

    click_on "Deal Flop"

    expect(page).to have_content "Frank Checks Mary Checks Rosco Checks"
    click_on "Deal Turn"
    expect(page).to have_content "Frank Checks Mary Checks Rosco Checks"
    click_on "Deal River"
    expect(page).to have_content "Frank Checks Mary Checks Rosco Checks"
    click_on "Show Winner"
    assert Game.last.winner

    click_on "Continue"

    #click on fold
    #what should you expect
    #finish out round

    #click_on Continue

    #click on fold
    #what is expected
    #finish out round

    #click on continue
    # click on fold
    #what is expected
    #finish out round
  end
end
