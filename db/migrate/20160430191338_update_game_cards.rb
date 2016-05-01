class UpdateGameCards < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :turn_card
      t.remove :river_card
      t.text :turn_card, array: true, default: []
      t.text :river_card, array: true, default: []
    end
  end
end
