class CreateAiPlayers < ActiveRecord::Migration
  def change
    create_table :ai_players do |t|
      t.string :name
      t.integer :skill
      t.string :bet_style
      t.integer :cash

      t.timestamps null: false
    end
  end
end
