class ChangeDefaultStartingCash < ActiveRecord::Migration
  def change
    change_column_default(:users, :cash, 2000)
  end
end
