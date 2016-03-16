class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :winner
      t.integer :bets
      t.string :hands
      t.string :pocket_cards
      t.string :flop
      t.string :turn
      t.string :river

      t.timestamps null: false
    end
  end
end
