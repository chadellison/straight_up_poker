== README

Overview

[Visit site here](https://straight-holdem.herokuapp.com)
This app was designed to create an interface for users to play Texas Holdem against various
AIs. This app will utilize java script, rails, and active record.

To play, Users must create an account and then simply click play. Users will select
the number of players, the amount of cash each player will start with, and both the
little and big blinds.

Users will be able to select a number of opponents, place bets and play hold'em
just as one would expect. AI's will make bets according to
the strength of their hands with a percentage(based on how good or bad a hand is) to
do something unpredictable. Not all AI's will respond the same in the same situation, but will have unique responses according to their bet styles.

Hosting
This app will be hosted through Heroku

* Ruby version: 2.3.0

* System dependencies
The Gem file is located [here](https://github.com/chadellison/straight_up_poker/blob/master/Gemfile)
* Configuration

* Database creation
This app will use a postgres database
* Database initialization

* How to run the test suite
The test suite can be run with rspec

* Deployment instructions

<tt>rake doc:app</tt>.
