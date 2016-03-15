class Card < ActiveRecord::Base
  def present_card
    "#{value} of #{suit}"
  end
end
