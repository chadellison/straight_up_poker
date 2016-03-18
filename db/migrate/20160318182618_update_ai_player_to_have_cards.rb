class UpdateAiPlayerToHaveCards < ActiveRecord::Migration
  def change
    change_table :ai_players do |t|
      t.string :cards, array: true, default: []
    end
  end
end
