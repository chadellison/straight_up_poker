require 'rails_helper'

RSpec.describe AiPlayer, type: :model do
  it {should have_many(:cards)}
end
