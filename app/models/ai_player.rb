class AiPlayer < ActiveRecord::Base
  has_many :cards

  def bet(amount)
    update(last_bet: amount)
    new_amount = cash - amount
    update(cash: new_amount)
  end

  def check
    "#{name} Checks!"
  end
end
