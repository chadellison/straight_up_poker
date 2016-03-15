class Updategametableagainforarray < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :flop
      t.remove :turn
      t.remove :river
      t.string :flop, array: true, default: []
      t.string :turn
      t.string :river
    end
  end
end
