class DropUserGamesTable < ActiveRecord::Migration
  def change
    drop_table :user_games
  end
end
