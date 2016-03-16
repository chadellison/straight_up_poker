class UpdateGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :flop_card_ids
      t.remove :turn_card_id
      t.remove :river_card_id
      t.string :flop_card_ids, array: true, default: []
      t.integer :turn_card_id
      t.integer :river_card_id
    end
  end
end
