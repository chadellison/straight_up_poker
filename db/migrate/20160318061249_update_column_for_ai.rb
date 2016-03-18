class UpdateColumnForAi < ActiveRecord::Migration
  def change
    change_table :ai_players do |t|
      t.remove :game_id
      t.string :cards, array: true, default: []
    end
  end
end
