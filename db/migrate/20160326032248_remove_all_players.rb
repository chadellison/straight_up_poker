class RemoveAllPlayers < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :all_players
    end
  end
end
