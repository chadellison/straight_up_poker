class RemoveSkillAttribute < ActiveRecord::Migration
  def change
    change_table :ai_players do |t|
      t.remove :skill
    end
  end
end
