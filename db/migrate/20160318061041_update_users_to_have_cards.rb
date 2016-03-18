class UpdateUsersToHaveCards < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :cards, array: true, default: []
    end
  end
end
