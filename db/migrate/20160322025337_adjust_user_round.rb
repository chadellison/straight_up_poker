class AdjustUserRound < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :round
      t.integer :round, :integer, default: 0
    end
  end
end
