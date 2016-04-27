class AddAvatar < ActiveRecord::Migration
  def change
    change_table :ai_players do |t|
      t.string :avatar
    end
  end
end
