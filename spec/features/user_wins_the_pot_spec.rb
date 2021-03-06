require "rails_helper"

RSpec.feature "user can win the pot" do
  scenario "users sees money deposited into account" do
    User.create(name: "jones", username: "jones", password: "password")
    AiPlayer.create(name: "Oscar")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    expect(page).to have_content "Welcome jones"

    click_on "Play"

    select "2", from: "Player count"
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

    expect(Game.last.pot).to eq 400

    ace = ["ACE", "Spades"]
    ace2 = ["ACE", "Hearts"]

    two = ["2", "Hearts"]
    three = ["3", "Hearts"]

    ace = ["ACE", "Clubs"]
    king = ["KING", "Spades"]
    king2 = ["KING", "Diamonds"]

    turn = ["5", "Clubs"]
    river = ["9", "Diamonds"]

    User.last.update(cards: [ace, ace2])
    AiPlayer.last.update(cards: [two, three])

    Game.last.update(flop_cards: [ace, king, king2])
    Game.last.update(turn_card: turn)
    Game.last.update(river_card: river)
    expect(User.last.cash).to eq 1800

    click_on "Show Winner"

    expect(page).to have_content "jones wins with a Full House!"
    expect(Game.last.pot).to eq 400
    expect(User.last.cash).to eq 2200

    click_on "Continue"

    expect(User.last.cash).to eq 2000
  end

  scenario "takes the pot" do
    User.create(name: "jones", username: "jones", password: "password")
    AiPlayer.create(name: "Oscar")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    expect(page).to have_content "Welcome jones"

    click_on "Play"

    select "2", from: "Player count"
    select "3000", from: "Buy in"
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

    expect(Game.last.pot).to eq 400

    ace = ["ACE", "Spades"]
    ace2 = ["ACE", "Hearts"]

    two = ["2", "Hearts"]
    three = ["3", "Hearts"]

    ace = ["ACE", "Clubs"]
    king = ["KING", "Spades"]
    king2 = ["KING", "Diamonds"]

    turn = ["5", "Clubs"]
    river = ["9", "Diamonds"]

    User.last.update(cards: [two, three])
    AiPlayer.last.update(cards: [ace, ace2])

    Game.last.update(flop_cards: [ace, king, king2])
    Game.last.update(turn_card: turn)
    Game.last.update(river_card: river)

    click_on "Show Winner"
    expect(page).to have_content "Oscar wins with a Full House!"
    expect(page).to have_content "Full House"
    expect(page).to have_content "Oscar: ACE of Clubs, ACE of Hearts"
    expect(User.last.cash).to eq 1800
    expect(Game.last.pot).to eq 400
    expect(AiPlayer.last.cash).to eq 3200

    click_on "Continue"

    expect(AiPlayer.last.cash).to eq 3000
  end
end
