class UpdateGamesTableToHoldCardClusters < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :flop_card_ids
      t.remove :turn_card_id
      t.remove :river_card_id
      t.string :flop_cards, array: true, default: []
      t.string :turn_card
      t.string :river_card
    end
  end
end
