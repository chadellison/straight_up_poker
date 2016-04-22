class AddChampionToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.string :champion
    end
  end
end
