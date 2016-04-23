class UpdateBuyIn < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :buy_in, default: 1000
    end
  end
end
