class AddOutColumnToAi < ActiveRecord::Migration
  def change
    change_table :ai_players do |t|
      t.boolean :out, default: false
    end
  end
end
