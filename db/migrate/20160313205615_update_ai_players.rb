class UpdateAiPlayers < ActiveRecord::Migration
  def change
    add_column :ai_players, :cash, :integer, default: 1000
  end
end
