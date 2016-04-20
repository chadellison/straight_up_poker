class UpdateUserTableToHaveOut < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :out, default: false
    end
  end
end
