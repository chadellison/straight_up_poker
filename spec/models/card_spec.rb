require 'rails_helper'

RSpec.describe Card, type: :model do
  it "presents the cards" do
    card = Card.new("9", "Hearts")
    expect(card.present_card).to eq "9 of Hearts"
  end
end
