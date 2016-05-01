require 'rails_helper'

RSpec.describe Game, type: :model do

  it {should have_many(:ai_players)}
  it {should have_many(:users)}

  it "adds players to a game" do
    user = User.new
    player = AiPlayer.create(name: "Rosco")
    game = Game.create(player_count: 2)
    game.add_players(user)
    expect(game.ai_players.last).to eq player
  end

  it "sets the blinds" do
    player = AiPlayer.create(name: "Trump")
    user = User.create(name: "frank", username: "frank", password: "password", round: 0)
    game = Game.create(player_count: 2, little_blind: 50, big_blind: 100)

    game.ai_players << player
    game.users << user

    expect(player.cash).to eq 1000
    expect(user.cash).to eq 2000
    game.set_blinds
    user = User.find(user.id)
    player = AiPlayer.find(player.id)
    expect(user.cash).to eq 1950
    expect(player.cash).to eq 900
  end

  it "it deals pocket cards" do
    game = Game.create(player_count: 2)
    user = game.users.create(name: "Markus", username: "markus", password: "password")
    ai = game.ai_players.create(name: "Trump")

    expect(user.cards.count).to eq 0
    expect(ai.cards.count).to eq 0
    game.load_deck
    game.deal_pocket_cards(game.users)
    game.deal_pocket_cards(game.ai_players)
    expect(game.cards.count).to eq 48
    expect(user.cards.count).to eq 2
    expect(ai.cards.count).to eq 2

    four_player_game = Game.create(player_count: 4)
    user = four_player_game.users.create(name: "Jim", username: "jim", password: "password")
    ai1 = four_player_game.ai_players.create(name: "a")
    ai2 = four_player_game.ai_players.create(name: "b")
    ai3 = four_player_game.ai_players.create(name: "c")

    four_player_game.load_deck

    four_player_game.deal_pocket_cards(four_player_game.ai_players)
    four_player_game.deal_pocket_cards(four_player_game.users)
    expect(user.cards.count).to eq 2
    expect(ai1.cards.count).to eq 2
    expect(ai2.cards.count).to eq 2
    expect(ai3.cards.count).to eq 2
    expect(four_player_game.cards.count).to eq 44
  end

  it "loads a new deck for every game" do
    game = Game.create(player_count: 2, little_blind: 50, big_blind: 100)
    game.load_deck
    expect(game.cards.count).to eq 52
    game.deal_flop
    expect(game.cards.count).to eq 48
    game = Game.create
    game.load_deck
    expect(game.cards.count).to eq 52
  end

  it "can perform an action based on a user action" do
    game = Game.create
    game.users.create(name: "jones", username: "jones", password: "password", round: 0)
    game.ai_players.create(name: "Rosco")

    user_action = "check"
    expect(game.ai_action(user_action)).to eq ["Rosco Checks"]
  end

  it "can perform an action based on other ais actions" do
    game = Game.create
    game.users.create(name: "jones", username: "jones", password: "password", round: 1)
    game.ai_players.create(name: "Rosco")
    game.ai_players.create(name: "Oscar")

    expect(game.ai_action).to eq ["Oscar Checks","Rosco Checks"]
  end

  it "updates the state of the game" do
    game = Game.create
    expect(game.pocket_cards).to eq false
    game.update_game
    expect(game.pocket_cards).to eq true
    expect(game.flop).to eq false
    game.update_game
    expect(game.flop).to eq true
    expect(game.turn).to eq false
    game.update_game
    expect(game.turn).to eq true
    expect(game.river).to eq false
    game.update_game
    expect(game.river).to eq true
  end

  it "deals flop" do
    game = Game.create
    game.load_deck
    expect(game.cards.count).to eq 52
    game.deal_flop
    expect(game.cards.count).to eq 48
    expect(game.flop_cards.count).to eq 3
  end

  it "deals the turn" do
    game = Game.create
    game.load_deck
    expect(game.cards.count).to eq 52
    expect(game.turn_card).to eq []
    game.deal_turn
    expect(game.cards.count).to eq 50
    refute game.turn_card.empty?
  end

  it "deals the river" do
    game = Game.create
    game.load_deck
    expect(game.cards.count).to eq 52
    expect(game.river_card).to eq []
    game.deal_river
    expect(game.cards.count).to eq 50
    refute game.river_card.empty?
  end

  it "can determine the winner" do
    game = Game.create
    ai_player = game.ai_players.create(name: "Rosco")
    user = game.users.create(name: "jones", username: "jones", password: "password")
    ace = Card.new("Ace", "Hearts").present_card
    king = Card.new("King", "Hearts").present_card
    user.cards << ace
    user.cards << king

    two = Card.new("2", "Hearts").present_card
    three = Card.new("3", "clubs").present_card
    ai_player.cards << two
    ai_player.cards << three

    card1 = Card.new("Ace", "Spades").present_card
    card2 = Card.new("King", "Spades").present_card
    card3 = Card.new("Ace", "Clubs").present_card

    game.update(flop_cards: [card1, card2, card3])

    card4 = Card.new("7", "Hearts").present_card
    game.update(turn_card: card4)

    card5 = Card.new("9", "Clubs").present_card

    game.update(river_card: card5)
    expect(game.determine_winner).to eq "#{user.id} user"
  end

  it "finds all players by id" do
    game = Game.create
    user = game.users.create(name: "frank", username: "frank", password: "password", round: 0)
    ai_player = game.ai_players.create(name: "jill")

    expect(Game.last.find_players).to eq [User.find(user.id), AiPlayer.find(ai_player.id)]
  end

  it "resets all the game values except player count and blinds" do
    User.create(name: "Rosco",
                                   username: "Rosco",
                                   password: "Rosco",
                                   current_bet: 200,
                                   total_bet: 400,
                                   round: 0)

    AiPlayer.create(name: "Mia",
                                 current_bet: 200,
                                 total_bet: 400)

    Game.create(winner: "Rosco wins!",
    player_count: 4,
    little_blind: 150,
    big_blind: 300,
    bets: nil,
    hands: nil,
    pocket_cards: true,
    flop: true,
    turn: true,
    river: true,
    pot: 1200,
    cards: [["Ace", "Hearts"], ["King", "Spades"], ["9", "Diamonds"]],
    flop_cards: [["3", "Hearts"], ["King", "Hearts"], ["10", "Clubs"]],
    turn_card: ["7", "Spades"],
    river_card: ["6", "Diamonds"]
    )
    User.create(name: "Rosco",
                                   username: "Rosco",
                                   password: "Rosco",
                                   current_bet: 200,
                                   total_bet: 400)

    AiPlayer.create(name: "Mia",
                                 current_bet: 200,
                                 total_bet: 400)

    Game.last.users << User.last
    Game.last.ai_players << AiPlayer.last

    expect(Game.last.winner).to eq "Rosco wins!"
    expect(Game.last.pocket_cards).to eq true
    expect(Game.last.flop).to eq true
    expect(Game.last.turn).to eq true
    expect(Game.last.river).to eq true
    expect(Game.last.pot).to eq 1200
    expect(Game.last.cards.count).to eq 3
    expect(Game.last.flop_cards.count).to eq 3
    expect(Game.last.turn_card).to eq ["7", "Spades"]
    expect(Game.last.river_card).to eq ["6", "Diamonds"]

    expect(User.last.current_bet).to eq 200
    expect(User.last.total_bet).to eq 400

    Game.last.refresh
    expect(Game.last.player_count).to eq 4
    expect(Game.last.little_blind).to eq 150
    expect(Game.last.big_blind).to eq 300
    expect(Game.last.pot).to eq 450
    expect(Game.last.flop_cards).to eq []
    expect(Game.last.turn_card).to eq []
    expect(Game.last.river_card).to eq []
    refute Game.last.flop
    refute Game.last.turn
    refute Game.last.river
    refute Game.last.winner
    expect(Game.last.cards.count).to eq 48

    expect(User.last.current_bet).to eq 300
    expect(User.last.total_bet).to eq 300

    expect(AiPlayer.last.current_bet).to eq 150
    expect(AiPlayer.last.total_bet).to eq 150
  end

  it "does not allow players to raise once the raise count is 3" do
    game = Game.create(little_blind: 100, big_blind: 200)
    user = game.users.create(name: "jones", username: "jones", password: "password")
    oscar = game.ai_players.create(name: "Oscar", bet_style: "always raise")
    rosco = game.ai_players.create(name: "Rosco", bet_style: "always raise")
    expect(oscar.take_action).to eq "Oscar Raises $200.00"
    expect(rosco.take_action).to eq "Rosco Raises $200.00"
    expect(oscar.take_action).to eq "Oscar Raises $200.00"
    expect(rosco.take_action).to eq "Rosco Calls!"
    expect(oscar.take_action).to eq "Oscar Checks"
  end
end
