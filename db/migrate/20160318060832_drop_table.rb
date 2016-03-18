class DropTable < ActiveRecord::Migration
  def change
    drop_table :cards
    drop_table :games
  end
end
