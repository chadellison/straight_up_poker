class ChangeAiPlayers < ActiveRecord::Migration
  def change
    change_table :ai_players do |t|
      t.remove :cash
    end
  end
end
