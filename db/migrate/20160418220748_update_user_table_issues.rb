class UpdateUserTableIssues < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :integer
    end
  end
end
