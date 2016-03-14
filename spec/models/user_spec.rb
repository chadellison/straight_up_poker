require 'rails_helper'

RSpec.describe User, type: :model do
  it { validate_presence_of(:username) }
  it { validate_uniqueness_of(:username) }
  # it { validate_presence_of(:password) }
  it { should have_many(:cards)}
  it "has many games" do
    user = User.create(username: "jones", name: "Jones", password: "password")
    assert user.user_games
    assert user.games
  end
end
