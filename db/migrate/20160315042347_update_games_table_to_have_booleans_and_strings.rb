class UpdateGamesTableToHaveBooleansAndStrings < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :flop
      t.remove :turn
      t.remove :river
      t.boolean :flop, default: false
      t.string :flop_cards, array: true, default: []
      t.boolean :turn, default: false
      t.string :turn_card
      t.boolean :river, default: false
      t.string :river_card
    end
  end
end
