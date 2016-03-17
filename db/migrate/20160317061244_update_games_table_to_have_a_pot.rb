class UpdateGamesTableToHaveAPot < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :pot, default: 0
    end
  end
end
