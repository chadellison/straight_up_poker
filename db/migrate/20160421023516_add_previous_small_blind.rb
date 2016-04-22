class AddPreviousSmallBlind < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.string :previous_small_blind
    end
  end
end
