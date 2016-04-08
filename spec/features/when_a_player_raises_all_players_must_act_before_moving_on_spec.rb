require "rails_helper"

RSpec.feature "when a player raises all other players must act before moving on" do
  scenario "users call, fold, or raise before the next cards are shown" do
    User.create(name: "jones", username: "jones", password: "password", cash: 10000)
    AiPlayer.create(name: "Frank", cash: 10000)
    AiPlayer.create(name: "Martha", bet_style: "always raise", cash: 10000)
    AiPlayer.create(name: "Rosco", cash: 10000)

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

    expect(page).to have_content "Little Blind: jones, $100.00"
    expect(page).to have_content "Big Blind: Frank, $200.00"
    expect(page).to have_content "Martha Raises $200.00"
    expect(page).to have_content "Rosco Calls!"

    click_on "Fold"
    expect(page).to have_content "Frank Calls!"

    expect(AiPlayer.all.all? { |ai| ai.total_bet == 400 }).to eq true
    click_on "Deal Flop"
    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Martha Raises $200.00"
    expect(page).to have_content "Rosco Calls!"

    expect(page).to have_content "Frank Calls!"
    expect(AiPlayer.all.all? { |ai| ai.total_bet == 600 }).to eq true
    click_on "Deal Turn"
    click_on "Deal River"
    click_on "Show Winner"

    expect(page).not_to have_content "Martha Raises $200.00"
    expect(page).not_to have_content "Rosco Calls!"
    expect(page).not_to have_content "Frank Calls!"
    click_on "Continue"

    #rosco, jones, frank, martha

    expect(page).to have_content "Little Blind: Rosco, $100.00"
    expect(page).to have_content "Big Blind: jones, $200.00"
    expect(page).to have_content "Frank Calls!"
    expect(page).to have_content "Martha Raises $200.00"
    expect(page).to have_content "Rosco Calls!"

    click_on "Call"
    expect(page).to have_content "Frank Calls!"
    expect(Game.last.find_players.all? do |player|
      player.total_bet == Game.last.highest_bet
    end).to eq true
    click_on "Deal Flop"

    expect(page).to have_content "Rosco Checks"
    click_on "Check"

    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Martha Raises $200.00"
    expect(page).to have_content "Rosco Calls"
    expect(page).not_to have_content "Frank Calls"

    click_on "Call"

    expect(page).to have_content "Frank Calls"
    click_on "Deal Turn"

    expect(page).to have_content "Rosco Checks"
    click_on "Check"

    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Martha Raises $200.00"
    expect(page).to have_content "Rosco Calls"
    expect(page).not_to have_content "Frank Calls"

    click_on "Call"
    expect(page).to have_content "Frank Calls"

    click_on "Deal River"

    click_on "Check"

    click_on "Call"
    click_on "Show Winner"

    click_on "Continue"

    #martha, rosco, jones, frank

    expect(page).to have_content "Little Blind: Martha, $100.00"
    expect(page).to have_content "Big Blind: Rosco, $200.00"

    expect(page).not_to have_content "Frank Calls!"
    expect(page).not_to have_content "Martha Raises $200.00"
    expect(page).not_to have_content "Rosco Calls!"

    click_on "Call"
    expect(page).to have_content "Frank Calls!"
    expect(page).to have_content "Martha Raises $200.00"
    expect(page).to have_content "Rosco Calls!"
    click_on "Call"
    expect(page).to have_content "Frank Calls!"

    expect(Game.last.find_players.all? do |player|
      player.total_bet == Game.last.highest_bet
    end).to eq true

    click_on "Deal Flop"
    expect(page).to have_content "Martha Raises $200.00"
    expect(page).to have_content "Rosco Calls!"
    expect(page).not_to have_content "Frank Calls!"

    click_on "Call"
    expect(page).to have_content "Frank Calls!"

    expect(Game.last.find_players.all? do |player|
      player.total_bet == Game.last.highest_bet
    end).to eq true

    click_on "Deal Turn"
    expect(page).to have_content "Martha Raises $200.00"
    expect(page).to have_content "Rosco Calls!"
    expect(page).not_to have_content "Frank Calls!"

    click_on "Call"
    expect(page).to have_content "Frank Calls"

    expect(Game.last.find_players.all? do |player|
      player.total_bet == Game.last.highest_bet
    end).to eq true

    click_on "Deal River"
    expect(page).to have_content "Martha Raises $200.00"
    expect(page).to have_content "Rosco Calls!"
    expect(page).not_to have_content "Frank Calls!"

    click_on "Call"
    expect(page).to have_content "Frank Calls"

    expect(Game.last.find_players.all? do |player|
      player.total_bet == Game.last.highest_bet
    end).to eq true

    click_on "Show Winner"

    click_on "Continue"

    #frank, martha, rosco, jones
    expect(page).to have_content "Little Blind: Frank, $100.00"
    expect(page).to have_content "Big Blind: Martha, $200.00"
    expect(page).to have_content "Rosco Calls!"
    click_on "Call"
    expect(page).to have_content "Frank Calls! Martha Raises $200.00 Rosco Calls!"

    click_on "Call"
    expect(page).to have_content "Frank Calls!"

    click_on "Deal Flop"

    expect(page).to have_content "Frank Checks! Martha Raises $200.00 Rosco Calls"
    expect(page).not_to have_content "Frank Calls"

    click_on "Call"
    expect(page).to have_content "Frank Calls!"
    expect(page).not_to have_content "Martha Raises $200.00"
    expect(page).not_to have_content "Rosco Calls!"

    click_on "Deal Turn"

    expect(page).to have_content "Frank Checks! Martha Raises $200.00 Rosco Calls"
    expect(page).not_to have_content "Frank Calls"

    click_on "Call"

    expect(page).to have_content "Frank Calls!"
    expect(page).not_to have_content "Martha Raises $200.00"
    expect(page).not_to have_content "Rosco Calls!"

    click_on "Deal River"

    expect(page).to have_content "Frank Checks! Martha Raises $200.00 Rosco Calls"
    expect(page).not_to have_content "Frank Calls"

    click_on "Call"

    expect(page).to have_content "Frank Calls!"
    expect(page).not_to have_content "Martha Raises $200.00"
    expect(page).not_to have_content "Rosco Calls!"

    expect(Game.last.find_players.all? do |player|
      player.total_bet == Game.last.highest_bet
    end).to eq true

    click_on "Show Winner"
  end
end
