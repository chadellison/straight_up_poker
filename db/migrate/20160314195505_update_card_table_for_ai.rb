class UpdateCardTableForAi < ActiveRecord::Migration
  def change
    change_table :cards do |t|
      t.integer :ai_player_id
    end
  end
end
