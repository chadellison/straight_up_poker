class UpdateUserTableDefault < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :round
      t.integer :round, default: 0
    end
  end
end
