class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_bet, :integer, default: 0
  end
end
