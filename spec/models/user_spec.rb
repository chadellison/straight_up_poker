require 'rails_helper'

RSpec.describe User, type: :model do
  it "has many games" do
    user = User.create(username: "jones", name: "Jones", password: "password")
    assert user.user_games
    assert user.games
  end
end
