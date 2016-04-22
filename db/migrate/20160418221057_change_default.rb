class ChangeDefault < ActiveRecord::Migration
  def change
    change_column :users, :action, :boolean, default: false
  end
end
