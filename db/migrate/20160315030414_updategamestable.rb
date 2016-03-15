class Updategamestable < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :pocket_cards
      t.remove :flop
      t.remove :turn
      t.remove :river
      t.boolean :pocket_cards, default: false
      t.boolean :flop, default: false
      t.boolean :turn, default: false
      t.boolean :river, default: false
    end
  end
end
