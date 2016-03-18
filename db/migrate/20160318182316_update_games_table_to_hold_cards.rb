class UpdateGamesTableToHoldCards < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.string :cards, array: true, default: []
    end
  end
end
