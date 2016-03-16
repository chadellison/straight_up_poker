class ChangeUsersColumn < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :cash
    end
  end
end
