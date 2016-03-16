class AddColumnToAiPlayers < ActiveRecord::Migration
  def change
    add_column :ai_players, :game_id, :integer
  end
end
