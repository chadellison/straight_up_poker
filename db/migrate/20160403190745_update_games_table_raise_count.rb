class UpdateGamesTableRaiseCount < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :raise_count, default: 0
    end
  end
end
