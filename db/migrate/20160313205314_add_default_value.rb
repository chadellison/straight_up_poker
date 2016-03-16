class AddDefaultValue < ActiveRecord::Migration
  def change
    add_column :users, :cash, :integer, default: 1000
  end
end
