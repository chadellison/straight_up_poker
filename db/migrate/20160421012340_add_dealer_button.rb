class AddDealerButton < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.string :previous_dealer_button
    end
  end
end
