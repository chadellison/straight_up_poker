class AdjustUserDefaultAgain < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :round
    end
  end
end
