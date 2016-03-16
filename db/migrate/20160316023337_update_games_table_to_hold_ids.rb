class UpdateGamesTableToHoldIds < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :flop_cards
      t.remove :turn_card
      t.remove :river_card
      t.string :flop_card_ids
      t.string :turn_card_id
      t.string :river_card_id
    end
  end
end
