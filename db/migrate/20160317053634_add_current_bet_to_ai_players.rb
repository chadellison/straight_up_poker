class AddCurrentBetToAiPlayers < ActiveRecord::Migration
  def change
    change_table :ai_players do |t|
      t.remove :last_bet
      t.integer :current_bet, default: 0
      t.integer :total_bet, default: 0
    end
  end
end
