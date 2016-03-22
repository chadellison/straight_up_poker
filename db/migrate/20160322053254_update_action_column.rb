class UpdateActionColumn < ActiveRecord::Migration
  def change
    change_table :ai_players do |t|
      t.boolean :action, default: false
    end
  end
end
