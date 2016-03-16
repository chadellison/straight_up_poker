class UpdateGamesColumn < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :players
      t.integer :player_count
    end
  end
end
