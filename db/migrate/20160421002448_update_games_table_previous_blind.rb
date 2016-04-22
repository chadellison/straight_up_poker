class UpdateGamesTablePreviousBlind < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.string :previous_blind
    end
  end
end
