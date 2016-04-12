require "rails_helper"

RSpec.feature "it can handle ties" do
  scenario "user splits the pot" do
    game = Game.create
    user = game.users.create(name: "jones", username: "jones", password: "password")
    oscar = game.ai_players.create(name: "Oscar")
    rosco = game.ai_players.create(name: "Rosco")

    card1 = Card.new("Ace", "Hearts")
    card2 = Card.new("Ace", "Diamonds")
    card3 = Card.new("Ace", "Spades")
    card4 = Card.new("Ace", "Clubs")
    card5 = Card.new("10", "Clubs")
    card6 = Card.new("10", "Spades")
    card7 = Card.new("10", "Hearts")
    card8 = Card.new("10", "Diamonds")
    card9 = Card.new("7", "Diamonds")
    card10 = Card.new("6", "Diamonds")
    card11 = Card.new("3", "Clubs")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"

    select "3", from: "Player count"
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

    Game.last.update(flop_cards: [card1.present_card, card2.present_card, card5.present_card])
    Game.last.update(turn_card: card6.present_card)
    Game.last.update(river_card: card9.present_card)

    User.find(user.id).update(cards: [card3.present_card, card11.present_card])
    AiPlayer.find(oscar.id).update(cards: [card4.present_card, card7.present_card])
    AiPlayer.find(rosco.id).update(cards: [card10.present_card, card8.present_card])

    click_on "Show Winner"

    expect(page).to have_content "jones and Oscar split the pot"
    expect(page).to have_content "jones: Ace of Spades, 3 of Clubs, Oscar: Ace of Clubs, 10 of Hearts"
  end
end
