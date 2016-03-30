class UpdateAiPlayerTableFolded < ActiveRecord::Migration
  def change
    change_table :ai_players do |t|
      t.boolean :folded, default: false
    end
  end
end
