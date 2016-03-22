class UpdateGamesTableToHaveAllPlayers < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.string :all_players, array: true, default: []
    end
  end
end
