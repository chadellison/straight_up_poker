class AddActionToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :action, default: true
    end
  end
end
