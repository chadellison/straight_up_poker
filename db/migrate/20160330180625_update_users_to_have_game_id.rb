class UpdateUsersToHaveGameId < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :game_id
    end
  end
end
