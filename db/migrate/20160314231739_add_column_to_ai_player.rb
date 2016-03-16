class AddColumnToAiPlayer < ActiveRecord::Migration
  def change
    add_column :ai_players, :last_bet, :integer, default: 0
  end
end
