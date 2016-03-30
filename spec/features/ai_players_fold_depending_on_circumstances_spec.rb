require "rails_helper"

RSpec.feature "ai players fold depending on the circumstances" do
  scenario "ai player is no longer part of the round" do
    user = User.create(name: "jones", username: "jones", password: "password")
    ai_player = AiPlayer.create(name: "Frankie")
    ai_player2 = AiPlayer.create(name: "Rick", bet_style: "always fold")

    visit root_path

    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_on "Login"

    click_on "Play"

    select "2", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    ace1 = Card.new("Ace", "Hearts")
    ace2 = Card.new("Ace", "Clubs")

    two = Card.new("2", "Clubs")
    seven = Card.new("7", "Clubs")

    Game.last.ai_players.last.update(cards: [ace1, ace2])
    Game.last.ai_players.first.update(cards: [two, seven])

    expect(page).to have_content "Rick folds!"

    click_on "Fold"
    expect(page).to have_content "Frankie wins!"
  end
end
