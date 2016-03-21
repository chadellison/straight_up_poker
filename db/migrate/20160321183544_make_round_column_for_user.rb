class MakeRoundColumnForUser < ActiveRecord::Migration
  def change
    add_column :users, :round, :integer, default: 1
  end
end
