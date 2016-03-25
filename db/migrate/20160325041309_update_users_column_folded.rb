class UpdateUsersColumnFolded < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :folded, default: false
    end
  end
end
