class AddUserRoundColumn < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :round, default: -1
    end
  end
end
